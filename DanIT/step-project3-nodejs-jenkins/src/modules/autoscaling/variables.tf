# Список імен для інстансів, які будуть створені в Auto Scaling Group
variable "instance_name" {
  type = list(string)
}

# ID образу Amazon Machine Image (AMI), що визначає операційну систему та налаштування інстансів
variable "ami" {}

# Тип EC2 інстансів, наприклад, t3.micro або m5.large
variable "instance_type" {}

# Ім'я ключа SSH для доступу до інстансів
variable "key_name" {}

# ID групи безпеки для контролю мережевого доступу до інстансів
variable "security_group_id" {}

# ID підмережі, де будуть розміщені інстанси
variable "subnet_id" {}

# Бажана кількість інстансів у групі автоматичного масштабування (Auto Scaling Group)
variable "desired_capacity" {}

# Максимальна кількість інстансів у групі автоматичного масштабування
variable "max_size" {}

# Мінімальна кількість інстансів у групі автоматичного масштабування
variable "min_size" {}

# Публічний ключ SSH, який буде додано до інстансів для забезпечення доступу
variable "ssh_public_key" {}

# ARN (Amazon Resource Name) цільової групи, до якої будуть приєднані інстанси
variable "target_group_arn" {}
