# Виводимо ідентифікатор створеної VPC з модуля VPC
output "vpc_id" {
  value = module.vpc.vpc_id  # Ідентифікатор VPC береться з вихідних даних модуля VPC
}

# Виводимо публічну IP-адресу створеного EC2 інстансу з модуля public_instance
output "public_instance_id" {
  value = module.public_instance.instance_public_ip  # Публічна IP-адреса інстансу береться з модуля EC2
}
