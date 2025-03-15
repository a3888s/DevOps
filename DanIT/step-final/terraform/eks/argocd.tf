resource "helm_release" "argocd" {
  name             = "argocd"                              # Назва релізу Helm
  repository       = "https://argoproj.github.io/argo-helm" # Репозиторій Helm для ArgoCD
  chart            = "argo-cd"                             # Назва чарту
  version          = "5.51.4"                              # Версія чарту
  namespace        = "argocd"                              # Kubernetes namespace для розгортання
  create_namespace = true                                  # Створення namespace, якщо його не існує

  values = [
    <<EOF
# Налаштування сервера ArgoCD
server:
  ingress:
    enabled: true                                          # Увімкнення Ingress
    annotations:                                          # Анотації для Ingress
      kubernetes.io/ingress.class: nginx                  # Використання Ingress класу nginx
      nginx.ingress.kubernetes.io/ssl-redirect: "false"   # Вимкнення редиректу на HTTPS
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP" # Вказівка на HTTP як протокол
    hosts:
      - "argocd.a3888s.test-danit.com"                    # Хост для доступу до ArgoCD (змініть на ваш)

  extraArgs:                                              # Додаткові аргументи для сервера
    - --insecure                                          # Дозвіл роботи без HTTPS

# Налаштування репозиторного сервера ArgoCD
repoServer:
  serviceAccount:
    create: true                                          # Створення ServiceAccount для repo-server
EOF
  ]
}
