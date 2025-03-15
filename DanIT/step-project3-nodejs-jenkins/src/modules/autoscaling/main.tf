# Налаштування Terraform для роботи з AWS як провайдером інфраструктури
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"  # Вказує версію AWS провайдера для забезпечення сумісності з поточною конфігурацією
    }
  }
}

# Створення шаблону запуску (Launch Template) для Auto Scaling Group
resource "aws_launch_template" "forstep3_launch_template" {
  image_id               = var.ami                 # Вибір AMI для інстансів
  instance_type          = var.instance_type       # Визначення типу EC2 інстанса
  key_name               = var.key_name            # Ім'я SSH ключа для доступу

  vpc_security_group_ids = [var.security_group_id] # Призначення групи безпеки для обмеження доступу

  # User Data - скрипт для ініціалізації інстанса, додає SSH ключ до авторизованих ключів
  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "${var.ssh_public_key}" >> /home/ubuntu/.ssh/authorized_keys
  EOF
  )

  # Додає теги до інстансів, запущених через цей шаблон
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name[0]  # Присвоєння інстансу назви з var.instance_name
    }
  }
}

# Auto Scaling Group для автоматичного масштабування інстансів на основі завантаження
resource "aws_autoscaling_group" "forstep3_autoscaling_group" {
  desired_capacity        = var.desired_capacity   # Початкова кількість інстансів
  max_size                = var.max_size           # Максимальна кількість інстансів для масштабування
  min_size                = var.min_size           # Мінімальна кількість інстансів
  vpc_zone_identifier     = [var.subnet_id]        # Список підмереж для розміщення інстансів

  # Призначає Launch Template для Auto Scaling Group
  launch_template {
    id      = aws_launch_template.forstep3_launch_template.id
    version = "$Latest"                           # Використання останньої версії шаблону запуску
  }

  # Прив'язує інстанси до цільової групи Load Balancer для балансування навантаження
  target_group_arns = var.target_group_arn

  # Додає теги до всіх інстансів у групі з автоматичним поширенням на запущені інстанси
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = var.instance_name[0]
  }

  health_check_type         = "EC2"              # Тип перевірки стану - EC2
  health_check_grace_period = 300                # Час очікування перед перевіркою стану інстанса після запуску

  lifecycle {
    create_before_destroy = true                 # Забезпечує безперервність при оновленні інстансів
  }
}

# Політика для Auto Scaling Group, що збільшує кількість інстансів при високому навантаженні
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.instance_name[0]}-scale-up"
  scaling_adjustment     = 1                    # Збільшує кількість інстансів на 1
  adjustment_type        = "ChangeInCapacity"   # Тип коригування - зміна кількості інстансів
  cooldown               = 300                  # Час очікування перед наступним масштабуванням
  autoscaling_group_name = aws_autoscaling_group.forstep3_autoscaling_group.name
}

# Політика для Auto Scaling Group, що зменшує кількість інстансів при зниженні навантаження
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.instance_name[0]}-scale-down"
  scaling_adjustment     = -1                   # Зменшує кількість інстансів на 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.forstep3_autoscaling_group.name
}

# Моніторинг завантаження CPU - масштабування вгору при високому завантаженні
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name             = "${var.instance_name[0]}-high-cpu"
  comparison_operator    = "GreaterThanThreshold"
  evaluation_periods     = 2                    # Кількість періодів, протягом яких повинна перевищувати поріг
  metric_name            = "CPUUtilization"
  namespace              = "AWS/EC2"
  period                 = 60
  statistic              = "Average"
  threshold              = 80                   # Поріг спрацьовування - 80% використання CPU
  alarm_actions          = [aws_autoscaling_policy.scale_up.arn]  # Запускає політику масштабування вгору

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.forstep3_autoscaling_group.name
  }
}

# Моніторинг завантаження CPU - масштабування вниз при низькому завантаженні
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name             = "${var.instance_name[0]}-low-cpu"
  comparison_operator    = "LessThanThreshold"
  evaluation_periods     = 2
  metric_name            = "CPUUtilization"
  namespace              = "AWS/EC2"
  period                 = 60
  statistic              = "Average"
  threshold              = 20                   # Поріг спрацьовування - 20% CPU
  alarm_actions          = [aws_autoscaling_policy.scale_down.arn]  # Запускає політику масштабування вниз

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.forstep3_autoscaling_group.name
  }
}

# Моніторинг використання пам'яті - масштабування вгору при високому використанні пам'яті
resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name             = "${var.instance_name[0]}-high-memory"
  comparison_operator    = "GreaterThanThreshold"
  evaluation_periods     = 2
  metric_name            = "MemoryUtilization"  # Використання пам'яті (потрібен CloudWatch Agent)
  namespace              = "CWAgent"
  period                 = 60
  statistic              = "Average"
  threshold              = 75                   # Поріг спрацьовування - 75% використання пам'яті
  alarm_actions          = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.forstep3_autoscaling_group.name
  }
}

# Моніторинг мережевого трафіку (вхідного) - масштабування вгору при високому навантаженні
resource "aws_cloudwatch_metric_alarm" "high_network_in" {
  alarm_name             = "${var.instance_name[0]}-high-network-in"
  comparison_operator    = "GreaterThanThreshold"
  evaluation_periods     = 2
  metric_name            = "NetworkIn"
  namespace              = "AWS/EC2"
  period                 = 60
  statistic              = "Average"
  threshold              = 50000000           # Поріг - 50 МБ/хв вхідного трафіку
  alarm_actions          = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.forstep3_autoscaling_group.name
  }
}
