# Вивід ID для Auto Scaling Group, що допомагає відстежувати та керувати групою автоматичного масштабування
output "autoscaling_group_id" {
  value = aws_autoscaling_group.forstep3_autoscaling_group.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.forstep3_autoscaling_group.name
}

# Вивід імені шаблону запуску (Launch Template), що використовується для створення інстансів у Auto Scaling Group
output "launch_template_name" {
  value = aws_launch_template.forstep3_launch_template.name
}
