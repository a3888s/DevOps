# Налаштовуємо AWS провайдер з використанням регіону, заданого у локальній змінній
provider "aws" {
  region = local.aws_region  # Регіон AWS береться з локальної змінної
}

# Шукаємо останню доступну AMI для Ubuntu 20.04 з SSD диском і віртуалізацією типу HVM
data "aws_ami" "latest_ubuntu" {
  most_recent = true  # Використовуємо найновішу доступну AMI

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]  # Фільтр для AMI на основі назви
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]  # Тип віртуалізації HVM
  }

  owners = ["099720109477"]  # Ідентифікатор власника AMI (Canonical, Ubuntu)
}

# Використовуємо модуль для створення VPC з підмережами і правилами доступу
module "vpc" {
  source = "../../modules/vpc"  # Шлях до модуля VPC
  vpc_cidr_block = var.vpc_cidr_block  # CIDR блок для VPC передається через змінну
  public_subnet_cidr = var.public_subnet_cidr  # CIDR блок для публічної підмережі
  list_of_open_ports = var.list_of_open_ports  # Список відкритих портів для Security Group
  vpc_name = local.vpc_name  # Назва VPC береться з локальної змінної
  vpc_tag = local.vpc_tags  # Теги для VPC беруться з локальної змінної
}

# Використовуємо модуль для створення EC2 інстансу з останньою AMI Ubuntu і встановленням Nginx
module "public_instance" {
  source = "../../modules/ec2"  # Шлях до модуля EC2 інстансу
  instance_type = var.instance_type  # Тип EC2 інстансу передається через змінну
  ami = data.aws_ami.latest_ubuntu.id  # Остання AMI Ubuntu для створення інстансу
  subnet_id = module.vpc.public_subnet_id  # Ідентифікатор публічної підмережі з модуля VPC
  security_group_id = module.vpc.public_sg_id  # Ідентифікатор Security Group з модуля VPC
  vpc_id = module.vpc.vpc_id  # Ідентифікатор VPC з модуля VPC
  user_data = file("/home/a3888s/my_danit_lesson/0_DZ/HW-20/src/envs/dev/scripts/install_nginx.sh")  # Скрипт для встановлення Nginx
  instance_name = local.instance_name  # Назва EC2 інстансу з локальної змінної
  instance_tag = local.instance_tags  # Теги для EC2 інстансу з локальної змінної
}
