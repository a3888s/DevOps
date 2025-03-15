output "s3_bucket" {
  value = aws_s3_bucket.hw21_bucket.id  # Виводить ідентифікатор створеного S3 бакету
}

output "dynamodb_table" {
  value = aws_dynamodb_table.hw21_locks_table.id  # Виводить ідентифікатор створеної таблиці DynamoDB
}
