# Отримання ID зони Route53, використовуючи назву зони
data "aws_route53_zone" "zone" {
  name         = var.zone_name      # Ім'я DNS-зони, вказане у змінній
  private_zone = false              # Публічна зона (не приватна)
}

# Локальна змінна для спрощеного доступу до імені домену
locals {
  domain_name = var.zone_name       # Призначення значення з var.zone_name локальній змінній
}

# Використання модуля ACM для створення сертифікатів
module "acm" {
  source  = "terraform-aws-modules/acm/aws"  # Використання офіційного модуля для ACM
  version = "~> 3.0"                         # Визначення версії модуля

  domain_name = local.domain_name            # Основний домен для сертифіката
  zone_id     = data.aws_route53_zone.zone.zone_id  # ID зони Route53 для прив'язки домену

  # Альтернативні імена для сертифіката
  subject_alternative_names = [
    "*.${local.domain_name}",                # Включення всіх піддоменів (wildcard)
  ]

  wait_for_validation = true                 # Очікування завершення перевірки сертифіката

  # Теги для організації ресурсів
  tags = merge(
    var.tags,                                # Злиття переданих тегів
    { Name = "${var.name}-eks" }             # Додатковий тег для ідентифікації
  )
}