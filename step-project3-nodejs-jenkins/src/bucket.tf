terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

# Конфігурація провайдера AWS, який вказує, в якому регіоні створювати ресурси
provider "aws" {
  region = var.aws_region
}

# Ресурс KMS (Key Management Service) для створення ключа шифрування.
# Ключ буде використовуватись для шифрування даних у S3.
resource "aws_kms_key" "my_key" {
  # Вказує, що ключ буде видалений через 10 днів після запиту на видалення.
  deletion_window_in_days = 10
}

# Ресурс для створення S3 бакету, який використовується для зберігання файлів.
resource "aws_s3_bucket" "forstep3_bucket" {
  bucket = var.s3_bucket_name   # Назва S3 бакету, яку отримуємо зі змінної
  force_destroy = true          # Автоматично видаляє бакет і всі об'єкти всередині, якщо бакет буде видалено

  tags = merge(
    var.s3_bucket_tags,
    {Environment = terraform.workspace}  # Додає теги для середовища Terraform (наприклад, dev або prod)
  )
}

# Увімкнення версійності для S3 бакету
resource "aws_s3_bucket_versioning" "forstep3_bucket_versioning" {
  bucket = aws_s3_bucket.forstep3_bucket.id  # Прив'язує версійність до попереднього бакету

  versioning_configuration {
    status = "Enabled"   # Вмикає версійність для бакету, що дозволяє зберігати кілька версій об'єктів
  }
}

# Конфігурація шифрування для S3 бакету, яка використовує KMS ключ для шифрування даних
resource "aws_s3_bucket_server_side_encryption_configuration" "forstep3_bucket_encryption" {
  bucket = aws_s3_bucket.forstep3_bucket.id  # Застосовує шифрування до створеного бакету

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.my_key.arn  # Використовує KMS ключ для шифрування
      sse_algorithm = "aws:kms"                   # Задає алгоритм шифрування KMS
    }
  }
}

# Ресурс DynamoDB для створення таблиці, яка може використовуватись для блокувань
# (наприклад, у Terraform, щоб уникнути конфліктів при оновленні інфраструктури)
resource "aws_dynamodb_table" "forstep3_locks_table" {
  name         = var.locks_name          # Ім'я таблиці, отримане зі змінної
  billing_mode = "PAY_PER_REQUEST"       # Оплата за фактичне використання, що підходить для нестабільних навантажень
  hash_key     = "LockID"                # Головний ключ таблиці - поле "LockID"

  # Визначення схеми атрибутів таблиці (в даному випадку це рядковий тип для "LockID")
  attribute {
    name = "LockID"
    type = "S"  # S означає "String", тобто рядковий тип
  }

  tags = merge(
    var.dynamodb_tags,
    {Environment = terraform.workspace}  # Додає тег середовища до таблиці (наприклад, dev або prod)
  )
}