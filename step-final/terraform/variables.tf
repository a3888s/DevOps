variable "aws_region" {
  type = string
  default = "eu-central-1"  # Регіон AWS для розгортання інфраструктури
}

variable "s3_bucket_name" {
  type = string
  default = "step-final-bucket"  # Назва S3 бакету для зберігання стану Terraform
}

variable "locks_name" {
  type = string
  default = "step-final-locks"  # Назва таблиці DynamoDB для блокування стану Terraform
}

variable "s3_bucket_tags" {
  type = map(string)
  default = {
    Name     = "step_final_bucket"  # Ім'я для позначення S3 бакету
    Owner    = "A3888S"       # Власник S3 бакету
  }
}

variable "dynamodb_tags" {
  type = map(string)
  default = {
    Name      = "step_final_locks"  # Ім'я для позначення таблиці DynamoDB
    Owner     = "A3888S"      # Власник таблиці DynamoDB
  }
}
