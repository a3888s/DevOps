# Створення групи безпеки для кластера EKS
resource "aws_security_group" "danit-cluster" {
  name        = "${var.name}-eks-sg"                        # Назва групи безпеки
  description = "Cluster communication with worker nodes"   # Опис призначення групи
  vpc_id      = var.vpc_id                                  # ID VPC, в якій розгортається кластер

  # Egress правила (дозволяє весь вихідний трафік)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                                      # Будь-який протокол
    cidr_blocks = ["0.0.0.0/0"]                             # Дозволяє весь вихідний трафік
  }

  # Теги для ідентифікації ресурсу
  tags = merge(
    var.tags,
    { Name = "${var.name}-eks-sg" }
  )
}

# Отримання зовнішнього IP робочої станції
data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"                         # Сервіс для визначення зовнішнього IP
}

# Локальна змінна для CIDR блоку робочої станції
locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.response_body)}/32" # CIDR блок для зовнішнього IP
}

# Правило безпеки для доступу до API-сервера кластера
resource "aws_security_group_rule" "kubeedge-cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]     # CIDR блок для IP робочої станції
  description       = "Allow workstation to communicate with the cluster API Server" # Опис правила
  from_port         = 443                                  # HTTPS порт
  protocol          = "tcp"                                # Протокол TCP
  security_group_id = aws_security_group.danit-cluster.id  # ID групи безпеки
  to_port           = 443                                  # HTTPS порт
  type              = "ingress"                            # Тип правила: вхідний трафік
}
