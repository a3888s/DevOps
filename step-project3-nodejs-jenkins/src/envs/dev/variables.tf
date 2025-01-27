# VPC та мережеві параметри
variable "vpc_name" {}                   # Ім'я для VPC
variable "vpc_cidr_block" {}              # CIDR блок для VPC
variable "public_subnet_name_1" {}        # Ім'я для першої публічної підмережі
variable "public_subnet_sidr_1" {}        # CIDR блок для першої публічної підмережі
variable "public_subnet_name_2" {}        # Ім'я для другої публічної підмережі
variable "public_subnet_sidr_2" {}        # CIDR блок для другої публічної підмережі
variable "private_subnet_name_1" {}       # Ім'я для першої приватної підмережі
variable "private_subnet_name_2" {}       # Ім'я для другої приватної підмережі
variable "private_subnet_sidr_1" {}       # CIDR блок для першої приватної підмережі
variable "private_subnet_sidr_2" {}       # CIDR блок для другої приватної підмережі
variable "aws_region" {}                  # Регіон AWS, де буде розгортатись інфраструктура
variable "availability_zone_1" {}         # Перша зона доступності
variable "availability_zone_2" {}         # Друга зона доступності
variable "list_of_open_ports" {}          # Список відкритих портів для безпеки

# EC2 параметри
variable "instance_count_on_demand" {}    # Кількість EC2 інстансів типу On-Demand
variable "instance_count_spot" {}         # Кількість Spot інстансів
variable "instance_type" {}               # Тип EC2 інстансів (наприклад, t3.micro)
variable "instance_names" {}              # Список імен для інстансів

# Load Balancer параметри
variable "lb_name" {}                     # Ім'я Load Balancer
variable "target_group_name" {}           # Ім'я цільової групи
variable "listener_name" {}               # Ім'я Listener для обробки трафіку

# RDS параметри
variable "db_name" {}                     # Ім'я бази даних
variable "username" {}                    # Ім'я користувача для доступу до бази
variable "password" {}                    # Пароль для доступу до бази
variable "instance_class" {}              # Клас RDS інстанса (наприклад, db.t3.micro)
variable "allocated_storage" {            # Виділене сховище для RDS (за замовчуванням 20 ГБ)
  type = number
  default = 20
}

# ElastiCache параметри
variable "cluster_id" {}                  # Ідентифікатор кластера ElastiCache
variable "node_type" {                    # Тип вузлів ElastiCache (за замовчуванням cache.t2.micro)
  default = "cache.t2.micro"
}
variable "num_cache_nodes" {              # Кількість вузлів у кластері (за замовчуванням 1)
  type = number
  default = 1
}
