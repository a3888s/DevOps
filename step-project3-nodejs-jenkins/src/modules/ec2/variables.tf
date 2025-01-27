# Кількість інстансів EC2, які будуть запущені
variable "instance_count" {
  default = 1
}

# Список імен для кожного EC2 інстанса (тип - список рядків)
variable "instance_names" {
  type = list(string)
}

# Тип EC2 інстанса, наприклад, t3.micro або t2.large
variable "instance_type" {}

# ID Amazon Machine Image (AMI), що визначає ОС і попереднє налаштування для інстанса
variable "ami" {}

# ID підмережі, в якій буде розміщений інстанс
variable "subnet_id" {}

# ID групи безпеки, яка буде застосована до інстанса
variable "security_group_id" {}

# Теги для інстанса, щоб допомогти з його організацією та ідентифікацією
variable "instance_tag" {}

# Ім'я ключа SSH для доступу до інстанса
variable "key_name" {}

# Публічний ключ SSH, який буде додано до інстанса для доступу
variable "ssh_public_key" {}

# Тип ринку EC2 інстансів: "on-demand" або "spot" (за замовчуванням - "on-demand")
variable "market_type" {
  type = string
  default = "on-demand"
}

# Максимальна ціна для spot інстансів (за замовчуванням порожня для on-demand інстансів)
variable "spot_price" {
  type = string
  default = ""
}
