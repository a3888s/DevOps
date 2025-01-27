terraform {
  # Вказує використовуваний провайдер і його версію
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

resource "aws_lb" "hw21_lb" {
  # Створює балансувальник навантаження (Load Balancer)
  name = var.lb_name                          # Ім'я балансувальника
  internal = false                            # Публічний (false) або внутрішній (true) LB
  load_balancer_type = "application"          # Тип LB (наприклад, application для HTTP/HTTPS)
  security_groups = [var.security_group_id]   # Група безпеки для контролю доступу
  subnets = [var.public_subnet_id_1, var.public_subnet_id_2] # Підмережі для розміщення LB
  enable_deletion_protection = false          # Вимкнення захисту від видалення

  tags = var.lb_tag                           # Теги для балансувальника
}

resource "aws_lb_target_group" "hw21_target_group" {
  # Створює цільову групу (Target Group) для балансувальника
  name = var.target_group_name                # Ім'я цільової групи
  port = 80                                   # Порт для перевірок і трафіку
  protocol = "HTTP"                           # Протокол для перевірок і трафіку
  vpc_id = var.vpc_id                         # Ідентифікатор VPC для групи

  health_check {                              # Налаштування перевірки стану (Health Check)
    path = "/"                                # Шлях для перевірки (root)
    protocol = "HTTP"                         # Протокол перевірки
    interval = 30                             # Інтервал перевірки в секундах
    timeout = 5                               # Час очікування перевірки в секундах
    healthy_threshold = 2                     # Кількість успішних перевірок для визнання інстансу здоровим
    unhealthy_threshold = 2                   # Кількість невдалих перевірок для визнання інстансу нездоровим
  }

  tags = var.lb_tag                           # Теги для цільової групи
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  # Прикріплює інстанси до цільової групи
  count = length(var.instance_ids)            # Кількість інстансів для прикріплення
  target_group_arn = aws_lb_target_group.hw21_target_group.arn  # ARN цільової групи
  target_id = var.instance_ids[count.index]   # ID прикріплюваного інстансу
}

resource "aws_lb_listener" "hw21_listener" {
  # Створює слухач (Listener) для балансувальника навантаження
  load_balancer_arn = aws_lb.hw21_lb.arn      # ARN балансувальника
  port = 80                                   # Порт для прийому трафіку
  protocol = "HTTP"                           # Протокол для прийому трафіку

  default_action {                            # Дія за замовчуванням для трафіку
    type = "forward"                          # Тип дії — перенаправлення на цільову групу
    target_group_arn = aws_lb_target_group.hw21_target_group.arn  # ARN цільової групи
  }
}
