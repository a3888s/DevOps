resource "aws_instance" "ec2_instance" {
  # Кількість створюваних інстансів, визначена змінною instance_count
  count = var.instance_count

  # Тип інстанса EC2, наприклад "t3.micro", визначається змінною instance_type
  instance_type = var.instance_type

  # AMI (Amazon Machine Image) для інстанса, вказана змінною ami
  ami = var.ami

  # Вибір підмережі для кожного інстанса на основі індексу, який обирає підмережу з доступних варіантів у списку subnet_id
  subnet_id = var.subnet_id[count.index % length(var.subnet_id)]

  # Групи безпеки, призначені для інстансів, вказані змінною security_group_id
  security_groups = [var.security_group_id]

  # Теги для інстансів, визначені у змінній instance_tag, для зручного управління
  tags = var.instance_tag
}
