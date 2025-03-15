# Основна змінна для іменування компонентів
variable "name" {
  description = "Назва інфраструктури або ресурсу"
}

# Змінна для VPC (Ідентифікатор існуючого VPC)
variable "vpc_id" {
  description = "Ідентифікатор VPC для розгортання інфраструктури"
}

# Змінна для підмереж (список підмереж, які будуть використовуватися)
variable "subnets_ids" {
  description = "Список підмереж, що використовуються в VPC"
}

# Змінна для тегів (глобальні теги для всіх ресурсів)
variable "tags" {
  description = "Глобальні теги для ресурсів Terraform"
}

# Змінна для регіону AWS
variable "region" {
  description = "Регіон AWS"
  default     = "eu-central-1"   # Значення за замовчуванням: Франкфурт
}

# Змінна для профілю AWS IAM
variable "iam_profile" {
  description = "Профіль AWS облікових даних"
  default     = null             # Значення за замовчуванням: null (може бути перевизначено)
}

# Змінна для назви DNS-зони
variable "zone_name" {
  description = "Назва DNS-зони, яка буде використовуватись"
}

# Закоментовані змінні для потенційного використання
# variable "vpc_cidr" {
#   description = "CIDR блок для VPC (за необхідністю створення нового VPC)"
# }
# variable "private_subnets" {
#   description = "Список приватних підмереж (за необхідністю створення нового VPC)"
# }
# variable "public_subnets" {
#   description = "Список публічних підмереж (за необхідністю створення нового VPC)"
# }
