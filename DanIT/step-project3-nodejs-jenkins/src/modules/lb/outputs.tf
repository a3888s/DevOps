# Вивід DNS імені Load Balancer для доступу до нього з Інтернету
output "lb_dns" {
  value = aws_lb.forstep3_lb.dns_name  # DNS ім'я балансувальника, використовується для доступу до нього
}

# Вивід ARN Load Balancer для ідентифікації та управління ресурсом
output "lb_arn" {
  value = aws_lb.forstep3_lb.arn       # Унікальний ідентифікатор (ARN) для Load Balancer
}

# Вивід ARN цільової групи, до якої Load Balancer перенаправляє трафік
output "target_group_arn" {
  value = aws_lb_target_group.forstep3_target_group.arn  # Унікальний ідентифікатор (ARN) цільової групи
}
