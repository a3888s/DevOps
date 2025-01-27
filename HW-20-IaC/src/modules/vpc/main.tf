# Створюємо VPC із заданим CIDR блоком
resource "aws_vpc" "hw20_vpc" {
  cidr_block = var.vpc_cidr_block  # CIDR блок для VPC задається через змінну
  tags       = var.vpc_tag  # Теги для VPC
}

# Створюємо публічну підмережу і дозволяємо інстансам у ній отримувати публічну IP-адресу
resource "aws_subnet" "hw20_public_subnet" {
  vpc_id                  = aws_vpc.hw20_vpc.id  # Прив'язуємо підмережу до VPC
  cidr_block              = var.public_subnet_cidr  # CIDR блок для підмережі задається через змінну
  map_public_ip_on_launch = true  # Дозволяємо публічні IP для інстансів у цій підмережі
  tags                    = var.vpc_tag  # Теги для підмережі
}

# Створюємо Інтернет-шлюз для доступу до інтернету
resource "aws_internet_gateway" "hw20_igw" {
  vpc_id = aws_vpc.hw20_vpc.id  # Прив'язуємо Інтернет-шлюз до VPC
  tags   = var.vpc_tag  # Теги для Інтернет-шлюзу
}

# Створюємо таблицю маршрутів для підмережі, з маршрутом через Інтернет-шлюз
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.hw20_vpc.id  # Прив'язуємо таблицю маршрутів до VPC

  # Додаємо маршрут, що дозволяє вихідний трафік на всі IP через Інтернет-шлюз
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hw20_igw.id
  }

  tags = var.vpc_tag  # Теги для таблиці маршрутів
}

# Прив'язуємо таблицю маршрутів до публічної підмережі
resource "aws_route_table_association" "hw20_public_association" {
  subnet_id      = aws_subnet.hw20_public_subnet.id  # Прив'язуємо таблицю маршрутів до підмережі
  route_table_id = aws_route_table.public_rt.id  # Вказуємо таблицю маршрутів
}

# Створюємо Security Group для публічної підмережі
resource "aws_security_group" "hw20_public_sg" {
  vpc_id = aws_vpc.hw20_vpc.id  # Прив'язуємо Security Group до VPC

  # Динамічно додаємо правила для відкритих портів зі списку
  dynamic "ingress" {
    for_each = toset(var.list_of_open_ports)  # Вказуємо список портів через змінну
    content {
      from_port   = ingress.value  # Відкриваємо порт для вхідного трафіку
      to_port     = ingress.value  # Відкриваємо той самий порт
      protocol    = "tcp"  # Протокол TCP
      cidr_blocks = ["0.0.0.0/0"]  # Дозволяємо доступ з будь-якої IP-адреси
    }
  }

  # Дозволяємо весь вихідний трафік
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Дозволяємо доступ до будь-якої IP-адреси
  }

  tags = var.vpc_tag  # Теги для Security Group
}
