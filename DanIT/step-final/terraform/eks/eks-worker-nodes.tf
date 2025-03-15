# Створення групи вузлів (Node Group) для EKS-кластера
resource "aws_eks_node_group" "danit-amd" {
  cluster_name    = aws_eks_cluster.danit.name        # Ім'я EKS-кластера, до якого додається група вузлів
  node_group_name = "${var.name}-amd"                # Ім'я групи вузлів, базується на значенні змінної var.name
  node_role_arn   = aws_iam_role.danit-node.arn      # ARN ролі IAM для вузлів
  subnet_ids      = var.subnets_ids                  # Підмережі, в яких будуть розгорнуті вузли

  # Конфігурація масштабування вузлів
  scaling_config {
    desired_size = 1                                 # Бажана кількість вузлів
    max_size     = 1                                 # Максимальна кількість вузлів
    min_size     = 1                                 # Мінімальна кількість вузлів
  }

  # Налаштування вузлів
  ami_type       = "AL2_x86_64"                     # Тип AMI для вузлів (Amazon Linux 2 для x86)
  instance_types = ["t3.large"]                    # Тип інстанса для вузлів

  # Додавання міток для вузлів
  labels = {
    "node-type" : "general"                         # Мітка, що визначає тип вузла
  }

  # Залежність від IAM політик для вузлів
  depends_on = [
    aws_iam_role_policy_attachment.kubeedge-node-AmazonEKSWorkerNodePolicy,          # Політика для роботи вузлів EKS
    aws_iam_role_policy_attachment.kubeedge-node-AmazonEKS_CNI_Policy,              # Політика для мережевого плагіна EKS CNI
    aws_iam_role_policy_attachment.kubeedge-node-AmazonEC2ContainerRegistryReadOnly, # Політика доступу до реєстру ECR
  ]

  # Теги для організації ресурсів
  tags = merge(
    var.tags,                                      # Теги, передані через змінну var.tags
    { Name = "${var.name}-amd-node-group" }        # Додатковий тег з ім'ям групи вузлів
  )
}
