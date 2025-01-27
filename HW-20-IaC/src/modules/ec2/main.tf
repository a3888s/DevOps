# Створюємо EC2 інстанс з використанням змінних для конфігурації
resource "aws_instance" "ec2_instance" {
  ami           = var.ami  # Вказуємо AMI для інстансу через змінну
  instance_type = var.instance_type  # Тип інстансу (наприклад, t3.micro) задається через змінну
  subnet_id     = var.subnet_id  # Ідентифікатор підмережі, де буде створений інстанс

  # Прив'язуємо Security Group для інстансу через змінну
  security_groups = [var.security_group_id]

  # Скрипт користувача (наприклад, для автоматичного встановлення Nginx) передається через змінну
  user_data     = var.user_data

  # Теги для інстансу передаються через змінну
  tags          = var.instance_tag
}
