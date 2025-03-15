output "load_balancer_dns" {
  # Виводить DNS-ім'я балансувальника навантаження (Load Balancer)
  value = aws_lb.hw21_lb.dns_name  # Отримує DNS-ім'я з ресурсу aws_lb для доступу до LB
}
