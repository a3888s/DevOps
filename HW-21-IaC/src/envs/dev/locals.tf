locals {
  project_name = "hw21"       # Назва проекту
  owner = "A3888S"            # Власник проекту
  environment = terraform.workspace

  # Теги для VPC ресурсу
  vpc_tags = {
    Name = var.vpc_name            # Ім'я VPC
    Project = local.project_name    # Назва проекту
    Environment = local.environment # Поточне середовище
    Owner = local.owner             # Власник проекту
  }

  # Теги для EC2 інстансів
  ec2_tags = {
    Name = var.instance_name        # Ім'я інстансу
    Project = local.project_name    # Назва проекту
    Environment = local.environment # Поточне середовище
    Owner = local.owner             # Власник проекту
  }

  # Теги для Load Balancer
  lb_tags = {
    Name = var.lb_name              # Ім'я Load Balancer
    Project = local.project_name    # Назва проекту
    Environment = local.environment # Поточне середовище
    Owner = local.owner             # Власник проекту
  }
}
