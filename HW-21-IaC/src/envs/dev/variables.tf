# CIDR блок для VPC, який визначає IP-адреси в межах вашої мережі.
variable "vpc_cidr_block" {}

# CIDR блок для першої публічної підмережі.
variable "public_subnet_sidr_1" {}

# CIDR блок для другої публічної підмережі.
variable "public_subnet_sidr_2" {}

# Регіон AWS, в якому будуть розгортатися ресурси.
variable "aws_region" {}

# Назва першої зони доступності, в якій буде створена підмережа.
variable "availability_zone_1" {}

# Назва другої зони доступності, в якій буде створена підмережа.
variable "availability_zone_2" {}

# Назва VPC для ідентифікації мережі.
variable "vpc_name" {}

# Назва підмережі для ідентифікації в AWS.
variable "subnet_name" {}

# Список портів, які будуть відкриті в Security Group.
variable "list_of_open_ports" {}

# Назва інстансу для ідентифікації EC2 у AWS.
variable "instance_name" {}

# Кількість EC2 інстансів, які будуть створені.
variable "instance_count" {}

# Тип інстансу EC2, наприклад, t2.micro, який визначає конфігурацію обладнання.
variable "instance_type" {}

# Назва балансувальника навантаження (Load Balancer).
variable "lb_name" {}

# Назва групи цілей для балансувальника навантаження.
variable "target_group_name" {}

# Назва слухача (listener) для балансувальника навантаження.
variable "listener_name" {}
