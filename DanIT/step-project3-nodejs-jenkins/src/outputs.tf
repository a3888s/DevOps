# Вивід ID S3 бакету для легкого доступу до нього з інших частин інфраструктури або для моніторингу
output "s3_bucket" {
  value = aws_s3_bucket.forstep3_bucket.id
}

# Вивід ID DynamoDB таблиці, яка використовується для блокувань у Terraform
output "dynamodb_table" {
  value = aws_dynamodb_table.forstep3_locks_table.id
}
