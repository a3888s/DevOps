# Змінна для визначення регіону AWS, за замовчуванням "us-east-1"
variable "aws_region" {
  type = string
  default = "us-east-1"
}

# Змінна для імені S3 бакета, який використовується для зберігання стану Terraform
variable "s3_bucket_name" {
  type = string
  default = "terraform-state-hw-20"
}

# Змінна для імені таблиці DynamoDB, яка використовується для блокування стану Terraform
variable "locks_name" {
  type = string
  default = "terraform_locks_HW_20"
}

# Змінна для тегів, які будуть застосовані до S3 бакета
variable "s3_bucket_tag" {
  type = map(string)
  default = {
    Name       = "terraform_state"  # Ім'я бакета
    Project    = "HW_20"            # Назва проекту
    ManagedBy  = "Terraform"        # Вказує, що керування здійснюється через Terraform
  }
}

# Змінна для тегів, які будуть застосовані до таблиці DynamoDB
variable "locks_tag" {
  type = map(string)
  default = {
    Name       = "terraform_locks"  # Ім'я таблиці DynamoDB
    Project    = "HW_20"            # Назва проекту
    ManagedBy  = "Terrafom"         # Вказує, що керування здійснюється через Terraform
  }
}
