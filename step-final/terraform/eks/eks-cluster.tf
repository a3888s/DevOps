# Створення EKS-кластера
resource "aws_eks_cluster" "danit" {
  name     = var.name                                  # Назва кластера, визначена у змінній var.name
  role_arn = aws_iam_role.cluster.arn                 # Роль IAM для кластера EKS

  # Налаштування мережі VPC для кластера
  vpc_config {
    security_group_ids = [aws_security_group.danit-cluster.id]  # ID групи безпеки для кластера
    subnet_ids         = var.subnets_ids                       # Списки підмереж для розгортання
  }

  # Залежність від IAM політик для кластера
  depends_on = [
    aws_iam_role_policy_attachment.kubeedge-cluster-AmazonEKSClusterPolicy,  # Політика для роботи кластера
    aws_iam_role_policy_attachment.kubeedge-cluster-AmazonEKSVPCResourceController, # Політика для VPC ресурсів
  ]

  # Теги для організації ресурсів
  tags = merge(
    var.tags,                                   # Теги, передані через змінну var.tags
    { Name = "${var.name}" }                   # Додатковий тег з назвою кластера
  )
}

# Отримання автентифікаційних даних для EKS-кластера
data "aws_eks_cluster_auth" "danit" {
  name = aws_eks_cluster.danit.name            # Назва кластера, створеного вище
}

# Додавання EKS-аддону CoreDNS
resource "aws_eks_addon" "coredns" {
  cluster_name                = var.name                       # Назва EKS-кластера
  addon_name                  = "coredns"                     # Ім'я аддона
  addon_version               = "v1.11.3-eksbuild.1"          # Версія CoreDNS (оновлена)
  resolve_conflicts_on_create = "OVERWRITE"                   # Вирішення конфліктів при створенні

  depends_on = [aws_eks_node_group.danit-amd]                 # Залежність від групи вузлів
}