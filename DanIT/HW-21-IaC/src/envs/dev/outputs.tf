# Ідентифікатор створеної VPC.
output "vpc_id" {
  value = module.vpc.vpc_id
}

# Список ідентифікаторів створених EC2 інстансів.
output "ec2_public_id" {
  value = module.ec2.ec2_instance_public_id
}

# Список публічних IP-адрес створених EC2 інстансів.
output "ec2_public_ip" {
  value = module.ec2.ect_instance_ips
}

# DNS-ім'я балансувальника навантаження.
output "lb_dns" {
  value = module.lb.load_balancer_dns
}
