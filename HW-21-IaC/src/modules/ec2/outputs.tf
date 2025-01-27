output "ec2_instance_public_id" {
  # Вивід ідентифікаторів усіх створених інстансів EC2, щоб можна було легко ідентифікувати інстанси
  value = aws_instance.ec2_instance[*].id
}

output "ect_instance_ips" {
  # Вивід публічних IP-адрес усіх створених інстансів EC2, для доступу до них через інтернет
  value = aws_instance.ec2_instance[*].public_ip
}