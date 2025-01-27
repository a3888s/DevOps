# Вивід ID для створеного VPC, що може використовуватись іншими модулями або ресурсами
output "vpc_id" {
  value = aws_vpc.forstep3_vpc.id
}

# Вивід ID для публічних підмереж, що може бути корисним для ресурсів, які потребують доступу до Інтернету
output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

# Вивід ID для приватних підмереж, що підходить для ресурсів, які не потребують публічного доступу
output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

# Вивід ID для створеної групи безпеки, що може використовуватись для налаштування доступу в інших ресурсах
output "security_group_id" {
  value = aws_security_group.forstep3_security_group.id
}
