# Регіон AWS, у якому будуть створені ресурси (за замовчуванням - us-east-1)
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# Ім'я для S3 бакету, де будуть зберігатись дані
variable "s3_bucket_name" {
  type    = string
  default = "forstep3-bucket"
}

# Ім'я для DynamoDB таблиці, яка буде використовуватись для блокувань
variable "locks_name" {
  type    = string
  default = "forstep3-locks"
}

# Теги для S3 бакету, щоб додати метаінформацію, таку як назва та власник ресурсу
variable "s3_bucket_tags" {
  type    = map(string)
  default = {
    Name  = "forstep3_bucket"
    Owner = "A3888S"
  }
}

# Теги для DynamoDB таблиці, щоб додати метаінформацію, таку як назва та власник ресурсу
variable "dynamodb_tags" {
  type    = map(string)
  default = {
    Name  = "forstep3_bucket"
    Owner = "A3888S"
  }
}
