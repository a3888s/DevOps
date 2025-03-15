# Змінна для імені VPC
variable "vpc_name" {
  type = string  # Тип даних - рядок
}

# Змінна для CIDR блоку VPC
variable "vpc_cidr_block" {
  type = string  # Тип даних - рядок (CIDR блок, наприклад, "10.0.0.0/16")
}

# Змінна для CIDR блоку публічної підмережі
variable "public_subnet_cidr" {
  type = string  # Тип даних - рядок (CIDR блок, наприклад, "10.0.1.0/24")
}

# Змінна для списку портів, які будуть відкриті в Security Group
variable "list_of_open_ports" {
  type = list(number)  # Тип даних - список чисел
  default = [80, 443]  # За замовчуванням відкриті порти для HTTP і HTTPS
}

# Змінна для тегів, що будуть застосовані до ресурсів VPC
variable "vpc_tag" {
  type = map(string)  # Тип даних - карта (ключ-значення)
}
