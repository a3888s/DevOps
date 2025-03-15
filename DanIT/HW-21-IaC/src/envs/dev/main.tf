# Вказує необхідного провайдера AWS та його версію.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

# Налаштування регіону AWS.
provider "aws" {
  region = var.aws_region
}

# Пошук останньої версії AMI з Ubuntu для EC2 інстансів.
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

# Створення ключа SSH для доступу до інстансів.
resource "aws_key_pair" "my-key" {
  key_name   = "ssh1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcwxkA0Wrd7MxwdqzcJyV7AilMGB8AL1g9hFgscDT8Gn6iNfS2/gFRn4Ngs3SlQRkjsJqDT+rrbAYBc3NJNq2sqKPzp1VdhutggHaaIYs4/y2UXshHwgau0LQoi2pV8Jm3bZ9vUs8mOBzKwcH52c+q4mpah5Xqb8DJQZSNOXRBIterE6GBn8NxtRLdSfkmingfXDdAF37OZsz6JDqPh4Y8zy+hUKQslHVyEqSjxFgymf5MqjnEvp+DFXK8FiCsM10byPeFuvTK1nfo/GJBivN7Dn+3/u7f4bLjfLjB+1KJODpYPd61SSldY8rOSWynzbCg8W45iBSpBs3awkPg1HaFMLoWpdTb27+Fc35sdDKERcJsCLPfPKXcV0TYkSR3yMzonc5iw+1vxqe71W08Zykz0QF+c84H84+FXofxq99cqk6y6oB0ozVCx37vJBmMPi4Z0zItJ0cHzP0c5LqXSGuDUnF4URrMie7IBh8tySYScjacmcn1r8xvC4ZRAr9Hb3M= a3888s@Dev"
}

# Модуль для створення VPC з двома публічними підмережами.
module "vpc" {
  source                 = "../../modules/vpc"
  vpc_cidr_block         = var.vpc_cidr_block
  public_subnet_cidr_1   = var.public_subnet_sidr_1
  public_subnet_cidr_2   = var.public_subnet_sidr_2
  list_of_open_ports     = var.list_of_open_ports
  availability_zone_1    = var.availability_zone_1
  availability_zone_2    = var.availability_zone_2
  vpc_name               = var.vpc_name
  subnet_name            = var.subnet_name
  vpc_tag                = local.vpc_tags
}

# Модуль для запуску EC2 інстансів з використанням останнього AMI та ключа доступу.
module "ec2" {
  source              = "../../modules/ec2"
  instance_count      = var.instance_count
  instance_type       = var.instance_type
  ami                 = data.aws_ami.latest_ubuntu.id
  subnet_id           = [module.vpc.public_subnet_id_1, module.vpc.public_subnet_id_2]
  security_group_id   = module.vpc.security_group_id
  key_name            = aws_key_pair.my-key.key_name
  instance_tag        = local.ec2_tags
}

# Модуль для створення Load Balancer, який розподіляє трафік між EC2 інстансами.
module "lb" {
  source               = "../../modules/load_balancer"
  lb_name              = var.lb_name
  target_group_name    = var.target_group_name
  listener_name        = var.listener_name
  security_group_id    = module.vpc.security_group_id
  public_subnet_id_1   = module.vpc.public_subnet_id_1
  public_subnet_id_2   = module.vpc.public_subnet_id_2
  vpc_id               = module.vpc.vpc_id
  instance_count       = var.instance_count
  instance_ids         = module.ec2.ec2_instance_public_id
  lb_tag               = local.lb_tags
}
