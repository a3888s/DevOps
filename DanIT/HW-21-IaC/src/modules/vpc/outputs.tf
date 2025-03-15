output "vpc_id" {
  value = aws_vpc.hw21_vpc.id  # Виводить ID створеної VPC
}

output "public_subnet_id_1" {
  value = aws_subnet.public_subnet_1.id  # Виводить ID першої публічної підмережі
}

output "public_subnet_id_2" {
  value = aws_subnet.public_subnet_2.id  # Виводить ID другої публічної підмережі
}

output "security_group_id" {
  value = aws_security_group.hw21_allow_http.id  # Виводить ID створеної групи безпеки
}