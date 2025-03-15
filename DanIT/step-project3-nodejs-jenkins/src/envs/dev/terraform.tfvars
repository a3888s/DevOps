# Основні параметри VPC та підмереж
vpc_name             = "forstep_vpc"
vpc_cidr_block       = "10.0.0.0/16"

public_subnet_name_1 = "forstep3_public_subnet_1"
public_subnet_sidr_1 = "10.0.1.0/24"
public_subnet_name_2 = "forstep3_public_subnet_2"
public_subnet_sidr_2 = "10.0.2.0/24"

private_subnet_name_1 = "forstep3_private_subnet_1"
private_subnet_sidr_1  = "10.0.3.0/24"
private_subnet_name_2 = "forstep3_private_subnet_2"
private_subnet_sidr_2  = "10.0.4.0/24"

# Параметри регіону та зон доступності
aws_region          = "eu-north-1"
availability_zone_1 = "eu-north-1a"
availability_zone_2 = "eu-north-1b"

# Група безпеки
list_of_open_ports  = [80, 443, 22, 8080, 50000]

# Налаштування для EC2 інстансів
instance_count_on_demand = "1"
instance_count_spot      = "1"
instance_type            = "t3.micro"
instance_names           = ["django-dev-app", "jenkins-dev-master", "jenkins-dev-worker"]

# Параметри для Load Balancer
lb_name            = "forstep3-lb"
target_group_name  = "forstep-target-group"
listener_name      = "forstep-listener"

# Налаштування для RDS (PostgreSQL)
db_name            = "forstepdb"
username           = "django"
password           = "u5Z25edY7L"
instance_class     = "db.t3.micro"
allocated_storage  = "20"

# Налаштування для Redis
cluster_id         = "forstep-cluster-redis"
node_type          = "cache.t3.micro"
num_cache_nodes    = 1
