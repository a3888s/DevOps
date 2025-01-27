locals {
  # Локальна змінна для назви проекту
  project_name = "hw20"

  # Локальна змінна для назви VPC
  vpc_name = "hw20_vpc"

  # Локальна змінна для регіону AWS
  aws_region = "eu-north-1"

  # Локальна змінна для назви EC2 інстансу
  instance_name = "hw20_public_instance"

  # Локальна змінна для поточного робочого простору Terraform
  environment = terraform.workspace

  # Теги для VPC
  vpc_tags = {
    vpc_name = local.vpc_name  # Назва VPC
    Project = local.project_name  # Назва проекту
    Environment = local.environment  # Поточне середовище (робочий простір Terraform)
  }

  # Теги для EC2 інстансу
  instance_tags = {
    instance_name = local.instance_name  # Назва інстансу
    Project = local.project_name  # Назва проекту
    Environment = local.environment  # Поточне середовище (робочий простір Terraform)
  }
}
