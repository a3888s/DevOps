variable "vpc_cidr_block" {
  # CIDR блок для створення VPC, наприклад "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  # CIDR блок для першої публічної підмережі в VPC, наприклад "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  # CIDR блок для другої публічної підмережі в VPC, наприклад "10.0.2.0/24"
}

variable "availability_zone_1" {
  # Назва першої зони доступності для першої публічної підмережі
}

variable "availability_zone_2" {
  # Назва другої зони доступності для другої публічної підмережі
}

variable "list_of_open_ports" {
  # Список відкритих портів для інгрес-правил безпеки, наприклад [80, 443, 22]
}

variable "vpc_tag" {
  # Мапа тегів для VPC і підмережі, наприклад { "Name" = "MyVPC", "Environment" = "dev" }
}

variable "vpc_name" {
  # Назва VPC для тегування ресурсу
}

variable "subnet_name" {
  # Назва публічних підмереж для тегування ресурсів
}
