terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

# Створення VPC з визначеним CIDR блоком і тегом Name
resource "aws_vpc" "forstep3_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

# Створення першої публічної підмережі з автопризначенням публічних IP-адрес для інстансів
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.forstep3_vpc.id
  cidr_block = var.public_subnet_sidr_1
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone_1

  tags = {
    Name = "PublicSubnet1"
  }
}

# Створення другої публічної підмережі
resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.forstep3_vpc.id
  cidr_block = var.public_subnet_sidr_2
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone_2

  tags = {
    Name = "PublicSubnet2"
  }
}

# Створення першої приватної підмережі без призначення публічних IP-адрес
resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.forstep3_vpc.id
  cidr_block = var.private_subnet_sidr_1
  availability_zone = var.availability_zone_1

  tags = {
    Name = "PrivateSubnet"
  }
}

# Створення другої приватної підмережі
resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.forstep3_vpc.id
  cidr_block = var.private_subnet_sidr_2
  availability_zone = var.availability_zone_2
}

# Створення Internet Gateway для виходу з публічних підмереж в Інтернет
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.forstep3_vpc.id

  tags = {
    Name = "igw"
  }
}

# Маршрутизаційна таблиця для публічних підмереж з маршрутом для виходу в Інтернет через Internet Gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.forstep3_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Асоціація першої публічної підмережі з маршрутизаційною таблицею для виходу в Інтернет
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Асоціація другої публічної підмережі з маршрутизаційною таблицею
resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Elastic IP для NAT Gateway (потрібен для вихідного доступу з приватних підмереж)
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "EIP"
  }
}

# Створення NAT Gateway у першій публічній підмережі для виходу з приватних підмереж
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet_1.id

  tags = {
    Name = "NatGateway"
  }
}

# Маршрутизаційна таблиця для приватних підмереж з маршрутом через NAT Gateway для виходу в Інтернет
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.forstep3_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

# Асоціація першої приватної підмережі з маршрутизаційною таблицею для NAT Gateway
resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

# Асоціація другої приватної підмережі з маршрутизаційною таблицею
resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

# Група безпеки з динамічними правилами для вхідного трафіку на основі заданих портів
resource "aws_security_group" "forstep3_security_group" {
  vpc_id = aws_vpc.forstep3_vpc.id

  # Динамічні правила вхідного трафіку для кожного порту з list_of_open_ports
  dynamic "ingress" {
    for_each = toset(var.list_of_open_ports)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

 # Доступ до Redis (порт 6379) для приватних IP-адрес у VPC
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
    description = "Allow Redis access within VPC"
  }

  # Доступ до RDS (порт 5432) для приватних IP-адрес у VPC
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
    description = "Allow RDS access within VPC"
  }

  # Egress (дозволяємо вихідні з'єднання)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "Forstep3SecurityGroup"
  }
}