terraform {
  backend "s3" {
    bucket         = "forstep3-bucket"           # Назва S3 бакету, в якому зберігається файл стану Terraform
    key            = "dev/terraform.tfstate"     # Шлях до файлу стану всередині S3 бакету
    region         = "us-east-1"                 # Регіон AWS, де розміщено S3 бакет
    dynamodb_table = "forstep3-locks"            # Таблиця DynamoDB для блокування стану, щоб уникнути конфліктів при одночасному доступі
    encrypt        = true                        # Шифрування файлу стану для додаткової безпеки
  }
}
