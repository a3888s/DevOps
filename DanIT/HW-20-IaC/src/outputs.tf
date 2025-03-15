# Виводить ідентифікатор S3 бакета, який використовується для зберігання стану Terraform
output "s3_bucket" {
  value = aws_s3_bucket.terraform_state.id
}

# Виводить ідентифікатор таблиці DynamoDB, яка використовується для блокування стану Terraform
output "dynamodb_table" {
  value = aws_dynamodb_table.terraform_locks.id
}
