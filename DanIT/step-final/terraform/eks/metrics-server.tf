# Встановлення Metrics Server через Helm
resource "helm_release" "metrics" {
  depends_on       = [aws_eks_node_group.danit-amd]         # Залежність: встановлення тільки після створення Node Group
  name             = "metrics-server"                      # Назва релізу Helm
  repository       = "https://kubernetes-sigs.github.io/metrics-server" # Репозиторій Helm для Metrics Server
  chart            = "metrics-server"                      # Назва чарту
  version          = "3.12.1"                              # Версія чарту
  namespace        = "kube-system"                         # Простір імен для встановлення
  create_namespace = true                                  # Створення namespace, якщо його немає
}
