resource "aws_db_subnet_group" "forstep_db_subnet_group" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

resource "aws_db_instance" "forstep_db_instance" {
  identifier           = var.db_name
  engine = "postgres"                     # Вибір бази даних PostgreSQL
  instance_class = var.instance_class             # Клас інстансу для RDS
  allocated_storage = var.allocated_storage          # Розмір дискового простору в ГБ
  db_name = var.db_name                    # Ім'я бази даних
  username = var.username                   # Ім'я користувача для бази даних
  password = var.password                   # Пароль для бази даних
  db_subnet_group_name = aws_db_subnet_group.forstep_db_subnet_group.name
  vpc_security_group_ids = [var.security_group_id]
  publicly_accessible = false                          # Не публікує RDS в Інтернет
  multi_az = true                           # Multi-AZ для відмовостійкості
  backup_retention_period = var.backup_retention_period    # Кількість днів зберігання резервних копій
  backup_window = var.backup_window              # Вікно для резервного копіювання
  skip_final_snapshot = true

  tags = {
    Name = var.db_name
  }
}


