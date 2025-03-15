# Вивід списку публічних IP-адрес для кожного EC2 інстанса
output "instance_public_ips" {
  value = aws_instance.ec2_instance[*].public_ip  # Отримує публічні IP-адреси всіх інстансів
}

# Вивід списку приватних IP-адрес для кожного EC2 інстанса
output "instance_private_ips" {
  value = aws_instance.ec2_instance[*].private_ip  # Отримує приватні IP-адреси всіх інстансів
}
