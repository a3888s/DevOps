terraform {
  backend "s3" {
    bucket         = "step-final-bucket"        # Назва S3 бакета для зберігання стану
    key            = "dev/terraform.tfstate" # Шлях до файлу стану для середовища "dev"
    region         = "eu-central-1"          # Регіон, де розміщено S3 бакет
    dynamodb_table = "step-final-locks"         # DynamoDB таблиця для блокування стану
    encrypt        = true                 # Шифрування стану для підвищення безпеки
  }
}
