resource "helm_release" "prometheus_stack" {
  name             = "kube-prometheus-stack"                 # Назва релізу Helm
  repository       = "https://prometheus-community.github.io/helm-charts" # Репозиторій Helm для Prometheus
  chart            = "kube-prometheus-stack"                # Назва чарту
  version          = "45.15.0"                              # Версія чарту
  namespace        = "monitoring"                           # Kubernetes namespace для розгортання
  create_namespace = true                                     # Створення namespace, якщо його не існує

  timeout = 900  # Тайм-ауту для уникнення помилок перевищення часу

  values = [
    <<EOF
# Налаштування Grafana
grafana:
  enabled: true
  adminPassword: "admin"                                      # Пароль для входу в Grafana
  ingress:
    enabled: true                                              # Увімкнення Ingress для Grafana
    annotations:
      kubernetes.io/ingress.class: nginx                       # Клас Ingress nginx
    hosts:
      - "grafana.a3888s.test-danit.com"                      # Хост для доступу до Grafana
    tls: []                                                    # Якщо потрібен TLS, додайте конфігурацію

# Налаштування Prometheus
prometheus:
  ingress:
    enabled: true                                              # Увімкнення Ingress для Prometheus
    annotations:
      kubernetes.io/ingress.class: nginx                       # Клас Ingress nginx
    hosts:
      - "prometheus.a3888s.test-danit.com"                   # Хост для доступу до Prometheus
    tls: []                                                    # Якщо потрібен TLS, додайте конфігурацію

# Налаштування Alertmanager
alertmanager:
  ingress:
    enabled: true                                              # Увімкнення Ingress для Alertmanager
    annotations:
      kubernetes.io/ingress.class: nginx                       # Клас Ingress nginx
    hosts:
      - "alertmanager.a3888s.test-danit.com"                 # Хост для доступу до Alertmanager
    tls: []                                                    # Якщо потрібен TLS, додайте конфігурацію

# Налаштування Node Exporter
nodeExporter:
  enabled: true                                                # Увімкнення Node Exporter для збору метрик вузлів
EOF
  ]
}
