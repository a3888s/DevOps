terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"  # Вказуємо версію AWS провайдера
    }
  }
}

provider "aws" {
  region = var.aws_region  # Вказуємо регіон AWS через змінну
}

# Створюємо ключ KMS для шифрування з 10-денною затримкою перед видаленням
resource "aws_kms_key" "my_key" {
  deletion_window_in_days = 10
}

# Створюємо S3 бакет для зберігання стану Terraform з автоматичним видаленням всіх об'єктів при видаленні бакета
resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.s3_bucket_name  # Ім'я бакета задається через змінну
  force_destroy = true  # Автоматично видаляємо всі об'єкти під час видалення бакета

  tags = merge(
    var.s3_bucket_tag,  # Теги для бакета
    { Environment = terraform.workspace }  # Додаємо тег Environment з робочим простором
  )
}

# Включаємо версіонування для S3 бакета
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.bucket  # Підключаємося до створеного бакета

  versioning_configuration {
    status = "Enabled"  # Включаємо версіонування
  }
}

# Включаємо шифрування на стороні сервера для S3 бакета з використанням KMS ключа
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.bucket  # Підключаємося до створеного бакета

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.my_key.arn  # Використовуємо ключ KMS для шифрування
      sse_algorithm     = "aws:kms"  # Використовуємо шифрування через AWS KMS
    }
  }
}

# Створюємо таблицю DynamoDB для блокування стану Terraform
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.locks_name  # Ім'я таблиці задається через змінну
  billing_mode = "PAY_PER_REQUEST"  # Оплата за використання таблиці
  hash_key     = "LockID"  # Основний ключ таблиці

  attribute {
    name = "LockID"
    type = "S"  # Тип основного ключа — рядок
  }

  tags = merge(
    var.locks_tag,  # Теги для таблиці
    { Environment = terraform.workspace }  # Додаємо тег Environment з робочим простором
  )
}
