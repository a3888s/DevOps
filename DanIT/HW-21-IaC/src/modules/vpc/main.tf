resource "aws_vpc" "hw21_vpc" {
  cidr_block = var.vpc_cidr_block  # CIDR блок для VPC, визначає діапазон IP адрес
  tags = {
    Name = var.vpc_name  # Тег "Name" для ідентифікації VPC
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.hw21_vpc.id  # Зв'язує підмережу з VPC
  cidr_block = var.public_subnet_cidr_1  # CIDR блок для першої публічної підмережі
  map_public_ip_on_launch = true  # Додає публічний IP автоматично до ресурсів у підмережі
  availability_zone = var.availability_zone_1  # Вказує на зону доступності
  tags = {
    Name = var.subnet_name  # Тег для ідентифікації підмережі
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.hw21_vpc.id
  cidr_block = var.public_subnet_cidr_2  # CIDR блок для другої публічної підмережі
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone_2  # Зона доступності для другої підмережі
  tags = {
    Name = var.subnet_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.hw21_vpc.id  # Підключає Internet Gateway до VPC
  tags = {
    Name = "igw"  # Тег для ідентифікації Internet Gateway
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.hw21_vpc.id  # Прив'язує таблицю маршрутизації до VPC
  route {
    cidr_block = "0.0.0.0/0"  # Створює маршрут для трафіку до Internet Gateway
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public route table"  # Тег для ідентифікації таблиці маршрутизації
  }
}

resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id = aws_subnet.public_subnet_1.id  # Підключає першу підмережу до таблиці маршрутизації
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id = aws_subnet.public_subnet_2.id  # Підключає другу підмережу до таблиці маршрутизації
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "hw21_allow_http" {
  vpc_id = aws_vpc.hw21_vpc.id  # Прив'язує групу безпеки до VPC

  dynamic "ingress" {
    for_each = toset(var.list_of_open_ports)  # Додає правила для кожного порту зі списку
    content {
      from_port = ingress.value  # Вказує порт початку діапазону
      to_port = ingress.value  # Вказує порт завершення діапазону
      protocol = "tcp"  # Використовує TCP протокол
      cidr_blocks = ["0.0.0.0/0"]  # Дозволяє доступ з будь-якої IP адреси
    }
  }

  egress {
    from_port = 0  # Вихідний трафік з будь-якого порту
    to_port = 0
    protocol = "-1"  # Дозволяє весь вихідний трафік
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.vpc_tag  # Теги для ідентифікації групи безпеки
}