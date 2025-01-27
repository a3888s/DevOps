# Налаштування Terraform для роботи з AWS як провайдером інфраструктури
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"      # Вказуємо провайдера AWS
      version = "5.54.1"             # Фіксуємо версію провайдера для сумісності конфігурації
    }
  }
}

# Вказуємо регіон, де буде розгортатися інфраструктура
provider "aws" {
  region = var.aws_region            # Регіон AWS, який вказується в змінній var.aws_region
}

# Вибір останнього доступного образу Ubuntu для створення EC2 інстансів
data "aws_ami" "latest_ubuntu" {
  most_recent = true                 # Використовуємо найновіший доступний образ
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] # Фільтр для пошуку Ubuntu 20.04
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]                 # Фільтр для образів з типом віртуалізації hvm
  }
  owners = ["099720109477"]          # Ідентифікатор власника образів Canonical (виробник Ubuntu)
}

# Створюємо SSH-ключ для доступу до EC2 інстансів
resource "aws_key_pair" "dev-key" {
  key_name   = "dev"                 # Ім'я ключа SSH для ідентифікації
  public_key = file("~/.ssh/id_rsa.pub") # Шлях до публічного ключа на вашому локальному комп'ютері
}

# Data Source для отримання списку інстансів Auto Scaling Group
data "aws_instances" "asg_instances" {
  instance_state_names = ["running"]
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [module.autoscaling_django_app.autoscaling_group_name]
  }
}

resource "local_file" "ansible_inventory" {
  filename = "/home/a3888s/code/forstep3/src/ansible/inventory.ini"

  content = <<-EOF
    [webserver]
    %{for ip in data.aws_instances.asg_instances.public_ips}
    ${ip}
    %{endfor}

    [jenkins-master]
    %{for ip in module.on_demand_ec2.instance_public_ips}
    ${ip}
    %{endfor}

    [jenkins-worker]
    %{for ip in module.spot_ec2.instance_private_ips}
    ${ip} ansible_ssh_common_args='-o ProxyJump=ubuntu@${module.on_demand_ec2.instance_public_ips[0]}'
    %{endfor}

    [all:vars]
    ansible_user=ubuntu
    ansible_ssh_private_key_file=~/.ssh/id_rsa
  EOF
}

# Налаштування модулю VPC, який створює віртуальну приватну мережу (VPC) з публічними і приватними підмережами, NAT і групами безпеки
module "vpc" {
  source                 = "../../modules/vpc"       # Шлях до модуля VPC
  vpc_name               = var.vpc_name              # Ім'я для VPC
  vpc_cidr_block         = var.vpc_cidr_block        # CIDR-блок для VPC, задає мережевий діапазон IP
  public_subnet_sidr_1   = var.public_subnet_sidr_1  # CIDR-блок першої публічної підмережі
  public_subnet_sidr_2   = var.public_subnet_sidr_2  # CIDR-блок другої публічної підмережі
  private_subnet_sidr_1  = var.private_subnet_sidr_1 # CIDR-блок першої приватної підмережі
  private_subnet_sidr_2  = var.private_subnet_sidr_2 # CIDR-блок другої приватної підмережі
  availability_zone_1    = var.availability_zone_1   # Перша зона доступності для високої доступності
  availability_zone_2    = var.availability_zone_2   # Друга зона доступності для високої доступності
  list_of_open_ports     = var.list_of_open_ports    # Список портів, що будуть відкриті для доступу
  vpc_tag                = local.vpc_tags            # Теги для VPC, що визначають середовище, проект і власника
}

# Модуль для створення Application Load Balancer, який розподіляє трафік між інстансами
module "lb" {
  source             = "../../modules/lb"             # Шлях до модуля Load Balancer
  lb_name            = var.lb_name                    # Ім'я Load Balancer
  target_group_name  = var.target_group_name          # Ім'я цільової групи, де реєструються інстанси
  listener_name      = var.listener_name              # Ім'я Listener, що обробляє HTTP/HTTPS трафік
  security_group_id  = module.vpc.security_group_id   # ID групи безпеки для LB, що дозволяє доступ ззовні
  public_subnet_id_1 = module.vpc.public_subnet_ids[0] # ID першої публічної підмережі для LB
  public_subnet_id_2 = module.vpc.public_subnet_ids[1] # ID другої публічної підмережі для LB
  vpc_id             = module.vpc.vpc_id              # ID VPC, в якій знаходиться Load Balancer
  lb_tag             = local.lb_tags                  # Теги для Load Balancer
}

# Модуль Auto Scaling створює групу інстансів для Django-додатку, яка може автоматично масштабуватися за навантаженням
module "autoscaling_django_app" {
  source             = "../../modules/autoscaling"    # Шлях до модуля Auto Scaling
  instance_name      = [var.instance_names[0]]        # Ім'я для інстансів Django-додатку
  ami                = data.aws_ami.latest_ubuntu.id  # Використовуємо AMI образ Ubuntu
  instance_type      = var.instance_type              # Тип інстанса (наприклад, t3.micro)
  key_name           = aws_key_pair.dev-key.key_name  # Ім'я ключа SSH для доступу
  security_group_id  = module.vpc.security_group_id   # ID групи безпеки для інстансів
  subnet_id          = module.vpc.public_subnet_ids[0] # Публічна підмережа для доступу з інтернету
  ssh_public_key     = aws_key_pair.dev-key.public_key # Публічний SSH ключ для доступу до інстансів

  # Параметри авто-масштабування
  desired_capacity   = 1                              # Кількість інстансів за замовчуванням
  max_size           = 5                              # Максимальна кількість інстансів
  min_size           = 1                              # Мінімальна кількість інстансів
  target_group_arn   = [module.lb.target_group_arn]   # Підключення інстансів до Load Balancer
}

# Модуль для On-Demand EC2 інстансів, які використовуються для критичних сервісів (наприклад, Jenkins Master)
module "on_demand_ec2" {
  source            = "../../modules/ec2"             # Шлях до модуля EC2
  instance_names    = [var.instance_names[1]]         # Ім'я для On-Demand інстансу
  instance_count    = var.instance_count_on_demand    # Кількість On-Demand інстансів
  instance_type     = var.instance_type               # Тип інстанса
  ami               = data.aws_ami.latest_ubuntu.id   # Образ Ubuntu для інстанса
  subnet_id         = module.vpc.public_subnet_ids[0] # Розміщення у публічній підмережі
  security_group_id = module.vpc.security_group_id    # Група безпеки для доступу
  key_name          = aws_key_pair.dev-key.key_name   # Ім'я ключа SSH
  ssh_public_key    = aws_key_pair.dev-key.public_key # Публічний ключ SSH для доступу
  market_type       = "on-demand"                     # Режим запуску On-Demand для надійності
  instance_tag      = local.ec2_tags                  # Теги для інстанса
}

# Модуль для Spot EC2 інстансів, що використовуються для економії на не критичних задачах (наприклад, Jenkins Worker)
module "spot_ec2" {
  source            = "../../modules/ec2"             # Шлях до модуля EC2
  instance_names    = [var.instance_names[2]]         # Ім'я для Spot інстансу
  instance_count    = var.instance_count_spot         # Кількість Spot інстансів
  instance_type     = var.instance_type               # Тип інстанса
  ami               = data.aws_ami.latest_ubuntu.id   # Образ Ubuntu для інстанса
  subnet_id         = module.vpc.private_subnet_ids[1] # Розміщення у приватній підмережі для безпеки
  security_group_id = module.vpc.security_group_id    # Група безпеки для доступу
  key_name          = aws_key_pair.dev-key.key_name   # Ім'я ключа SSH
  ssh_public_key    = aws_key_pair.dev-key.public_key # Публічний ключ SSH для доступу
  market_type       = "spot"                          # Режим запуску Spot для економії
  spot_price        = "0.05"                          # Максимальна ціна за годину для Spot інстанса
  instance_tag      = local.ec2_tags                  # Теги для інстанса
}

# Модуль для налаштування RDS (PostgreSQL), забезпечує захищене зберігання даних у приватних підмережах
module "rds" {
  source            = "../../modules/rds"             # Шлях до модуля RDS
  db_name           = var.db_name                     # Ім'я бази даних
  username          = var.username                    # Ім'я користувача для доступу до бази даних
  password          = var.password                    # Пароль для доступу до бази даних
  subnet_ids        = module.vpc.private_subnet_ids   # Приватні підмережі для захищеного розміщення
  security_group_id = module.vpc.security_group_id    # Група безпеки для контролю доступу
  instance_class    = var.instance_class              # Клас інстанса для RDS (наприклад, db.t3.micro)
  allocated_storage = var.allocated_storage           # Виділене сховище для RDS
}

# Модуль Redis (ElastiCache) для налаштування кластера Redis, використовується для кешування даних
module "redis" {
  source            = "../../modules/redis"           # Шлях до модуля Redis
  cluster_id        = var.cluster_id                  # Ідентифікатор кластера Redis
  subnet_ids        = module.vpc.private_subnet_ids   # Приватні підмережі для захищеного доступу
  security_group_id = module.vpc.security_group_id    # Група безпеки для контролю доступу
  node_type         = var.node_type                   # Тип вузла для Redis (наприклад, cache.t2.micro)
  num_cache_nodes   = var.num_cache_nodes             # Кількість вузлів у кластері для масштабованості
}