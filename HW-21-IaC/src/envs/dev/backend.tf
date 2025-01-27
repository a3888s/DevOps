terraform {
  backend "s3" {
    bucket         = "hw21-bucket"        # Назва S3 бакета для зберігання стану
    key            = "dev/terraform.tfstate" # Шлях до файлу стану для середовища "dev"
    region         = "us-east-1"          # Регіон, де розміщено S3 бакет
    dynamodb_table = "hw21-locks"         # DynamoDB таблиця для блокування стану
    encrypt        = true                 # Шифрування стану для підвищення безпеки
  }
}
