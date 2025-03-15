terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"  # Версія провайдера AWS
    }
  }
}

# Створення Application Load Balancer (ALB), який розподіляє вхідний HTTP-трафік
resource "aws_lb" "forstep3_lb" {
  name                  = var.lb_name               # Ім'я балансувальника
  internal              = false                     # Вказує, що балансувальник буде публічним
  load_balancer_type    = "application"             # Тип балансувальника - ALB (application load balancer)
  security_groups       = [var.security_group_id]   # Група безпеки для контролю доступу
  subnets               = [var.public_subnet_id_1, var.public_subnet_id_2] # Підмережі для розміщення в різних зонах доступності
  enable_deletion_protection = false                # Захист від видалення вимкнено

  tags = var.lb_tag                                # Теги для ідентифікації ресурсу
}

# Створення цільової групи, до якої Load Balancer буде направляти трафік
resource "aws_lb_target_group" "forstep3_target_group" {
  name     = var.target_group_name                 # Ім'я цільової групи
  port     = 80                                    # Порт для трафіку (HTTP)
  protocol = "HTTP"                                # Протокол передачі даних
  vpc_id   = var.vpc_id                            # VPC, у якій буде створено цільову групу

  # Налаштування перевірок стану здоров'я (health check) для інстансів у цільовій групі
  health_check {
    path                = "/"                      # Шлях для перевірки стану
    protocol            = "HTTP"                   # Протокол перевірки
    interval            = 30                       # Інтервал перевірки в секундах
    timeout             = 5                        # Тайм-аут перевірки в секундах
    healthy_threshold   = 2                        # Кількість успішних перевірок для визнання інстанса здоровим
    unhealthy_threshold = 2                        # Кількість невдалих перевірок для визнання інстанса нездоровим
  }

  tags = var.lb_tag                                # Теги для ідентифікації ресурсу
}

# Listener для обробки вхідного трафіку на Load Balancer
resource "aws_lb_listener" "forstep3_listener" {
  load_balancer_arn = aws_lb.forstep3_lb.arn       # ARN балансувальника навантаження
  port              = 80                           # Порт для прослуховування (HTTP)
  protocol          = "HTTP"                       # Протокол передачі даних

  # Дія за замовчуванням - перенаправлення трафіку до цільової групи
  default_action {
    type             = "forward"                   # Тип дії - перенаправлення
    target_group_arn = aws_lb_target_group.forstep3_target_group.arn  # ARN цільової групи
  }
}
