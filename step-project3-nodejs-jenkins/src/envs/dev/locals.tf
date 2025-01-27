locals {
  # Загальні параметри проекту
  project_name = "forstep3"                 # Ім'я проекту для ідентифікації
  owner = "A3888S"                          # Власник проекту для полегшення управління ресурсами
  environment = terraform.workspace          # Поточне робоче середовище Terraform (наприклад, dev, prod)

  # Теги для VPC
  vpc_tags = {
    Name        = var.vpc_name              # Ім'я VPC, отримане із змінної
    Project     = local.project_name        # Ім'я проекту
    Environment = local.environment         # Робоче середовище
    Owner       = local.owner               # Власник проекту
  }

  # Теги для EC2 інстансів
  ec2_tags = {
    Project     = local.project_name        # Ім'я проекту
    Environment = local.environment         # Робоче середовище
    Owner       = local.owner               # Власник проекту
  }

  # Теги для Load Balancer
  lb_tags = {
    Project     = local.project_name        # Ім'я проекту
    Environment  = local.environment         # Робоче середовище
    Owner       = local.owner               # Власник проекту
  }
}
