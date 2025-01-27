terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"  # Вказує версію провайдера AWS
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}

# Ресурс для створення одного або кількох EC2 інстансів
resource "aws_instance" "ec2_instance" {
  count = var.instance_count       # Кількість інстансів, що створюються на основі значення змінної

  instance_type = var.instance_type # Тип інстанса, наприклад, t3.micro
  ami = var.ami                     # ID образу Amazon Machine Image (AMI), наприклад, Ubuntu, Amazon Linux
  subnet_id = var.subnet_id         # ID підмережі, в якій інстанс буде розміщено
  security_groups = [var.security_group_id]  # Групи безпеки, які керують доступом до інстанса
  key_name = var.key_name           # Ім'я ключа SSH для доступу до інстанса

  # Скрипт, який додає публічний SSH ключ до авторизованих ключів користувача Ubuntu
  user_data = <<-EOF
    #!/bin/bash
    echo "${var.ssh_public_key}" >> /home/ubuntu/.ssh/authorized_keys
  EOF

  # Теги для організації та ідентифікації кожного інстанса
  tags = merge(var.instance_tag, {
    Name = var.instance_names[count.index]  # Встановлює ім'я для кожного інстанса зі списку
  })
}


