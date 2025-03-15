provider "aws" {
  region = var.aws_region
}

data "aws_ami" "latest_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# Виклик модуля для створення VPC
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  tags = local.common_tags
}

# Виклик модуля для створення публічного EC2
module "public_instance" {
  source            = "./modules/ec2"
  instance_type     = var.public_instance_type
  ami               = data.aws_ami.latest_ubuntu.id
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.vpc.public_sg_id
  instance_name     = "${local.project_name}-public-instance"
}

# Виклик модуля для створення приватного EC2
module "private_instance" {
  source            = "./modules/ec2"
  instance_type     = var.private_instance_type
  ami               = data.aws_ami.latest_ubuntu.id
  subnet_id         = module.vpc.private_subnet_id
  security_group_id = module.vpc.private_sg_id
  instance_name     = "${local.project_name}-private-instance"
}
