terraform {
  # Конфігурація для зберігання стану Terraform у S3 бакеті
  backend "s3" {
    bucket         = "terraform-state-hw-20"  # Ім'я S3 бакета для зберігання стану
    key            = "dev/terraform.tfstate"  # Шлях до файлу стану для середовища "dev"
    region         = "us-east-1"  # Регіон AWS, де знаходиться S3 бакет
    dynamodb_table = "terraform_locks_HW_20"  # Таблиця DynamoDB для блокування стану (щоб уникнути одночасних змін)
    encrypt        = true  # Шифрування стану в S3 для безпеки
  }
}
