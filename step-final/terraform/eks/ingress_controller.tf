# Встановлення nginx-ingress через Helm
resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"                           # Назва релізу
  repository       = "https://kubernetes.github.io/ingress-nginx" # Репозиторій Helm для nginx-ingress
  chart            = "ingress-nginx"                           # Назва чарту
  version          = "4.10.0"                                  # Версія чарту
  namespace        = "kube-system"                             # Простір імен для встановлення
  create_namespace = true                                      # Створення namespace, якщо він відсутній

  # Налаштування анотацій для використання AWS NLB (Network Load Balancer)
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = module.acm.acm_certificate_arn                     # ARN SSL сертифіката ACM
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "http"                                             # Протокол для бекенду
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
    value = "https"                                            # Порти для SSL
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "internet-facing"                                  # Схема - відкритий до Інтернету балансувальник
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"                                              # Тип балансувальника - Network Load Balancer
  }
  set {
    name  = "controller.service.targetPorts.http"
    value = "http"                                             # Цільовий порт для HTTP
  }
  set {
    name  = "controller.service.targetPorts.https"
    value = "http"                                             # Цільовий порт для HTTPS
  }
}
