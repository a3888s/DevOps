terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"  # Використовуємо певну версію провайдера AWS
    }
  }
}
provider "aws" {
  region = var.aws_region  # Встановлює регіон для AWS ресурсів
}

resource "aws_kms_key" "my_key" {
  deletion_window_in_days = 10  # Встановлює період видалення ключа KMS
}

resource "aws_s3_bucket" "hw21_bucket" {
  bucket = var.s3_bucket_name  # Назва S3 бакету для зберігання стану Terraform
  force_destroy = true  # Видаляє всі об'єкти при знищенні бакету

  tags = merge(
    var.dynamodb_tags,  # Додає тег для відстеження середовища
    {Environment = terraform.workspace}
  )
}

resource "aws_s3_bucket_versioning" "hw21_bucket_versioning" {
  bucket = aws_s3_bucket.hw21_bucket.id  # Включає версіонування бакету
  versioning_configuration {
    status = "Enabled"  # Встановлює статус версіонування на "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "hw21_bucket_encryption" {
  bucket = aws_s3_bucket.hw21_bucket.id  # Додає шифрування за допомогою KMS до бакету
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.my_key.arn  # Вказує ключ KMS для шифрування
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_dynamodb_table" "hw21_locks_table" {
  name = var.locks_name  # Назва таблиці DynamoDB для блокування стану Terraform
  billing_mode = "PAY_PER_REQUEST"  # Використовує оплату за запит
  hash_key = "LockID"  # Визначає атрибут для ідентифікації блокування
  attribute {
    name = "LockID"
    type = "S"  # Встановлює тип атрибуту як "String"
  }

  tags = merge(
    var.dynamodb_tags,  # Додає теги для таблиці
    {Environment = terraform.workspace}
  )
}
