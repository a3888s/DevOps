# CIDR блок для створення VPC, охоплює IP-адреси в межах мережі.
vpc_cidr_block = "10.0.0.0/16"

# CIDR блок для першої публічної підмережі.
public_subnet_sidr_1 = "10.0.1.0/24"

# CIDR блок для другої публічної підмережі.
public_subnet_sidr_2 = "10.0.2.0/24"

# Регіон AWS, в якому будуть створюватися ресурси.
aws_region = "eu-north-1"

# Перша зона доступності для підмережі.
availability_zone_1 = "eu-north-1a"

# Друга зона доступності для підмережі.
availability_zone_2 = "eu-north-1b"

# Назва VPC для ідентифікації мережі в AWS.
vpc_name = "hw21_vpc"

# Назва публічної підмережі для ідентифікації.
subnet_name = "hw21_public_subnet"

# Список відкритих портів у Security Group.
list_of_open_ports = [80, 443, 22]

# Назва EC2 інстансу.
instance_name = "hw21_public_instance"

# Кількість EC2 інстансів, які потрібно створити.
instance_count = "2"

# Тип EC2 інстансу для вибору конфігурації.
instance_type = "t3.micro"

# Назва балансувальника навантаження (Load Balancer).
lb_name = "hw21-lb"

# Назва групи цілей (Target Group) для LB.
target_group_name = "hw21-target-group"

# Назва слухача (Listener) для балансувальника.
listener_name = "hw21_listener"
