# Виводимо ідентифікатор створеної VPC
output "vpc_id" {
  value = aws_vpc.hw20_vpc.id
}

# Виводимо ідентифікатор створеної публічної підмережі
output "public_subnet_id" {
  value = aws_subnet.hw20_public_subnet.id
}

# Виводимо ідентифікатор створеної Security Group для публічної підмережі
output "public_sg_id" {
  value = aws_security_group.hw20_public_sg.id
}
