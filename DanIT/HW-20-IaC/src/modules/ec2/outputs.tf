# Виводимо публічну IP-адресу створеного EC2 інстансу
output "instance_public_ip" {
  value = aws_instance.ec2_instance.public_ip  # Публічна IP-адреса EC2 інстансу
}
