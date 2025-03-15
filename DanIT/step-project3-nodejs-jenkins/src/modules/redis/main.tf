terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"  # Вказує версію провайдера AWS
    }
  }
}

# Створення групи підмереж для ElastiCache кластера
resource "aws_elasticache_subnet_group" "forstep_aws_elasticache_subnet_group" {
  name       = "${var.cluster_id}-subnet-group"  # Ім'я групи підмереж для ElastiCache
  subnet_ids = var.subnet_ids                    # Підмережі, де будуть розміщені вузли кластера

  tags = {
    Name = "${var.cluster_id}-subnet-group"      # Теги для групи підмереж
  }
}

# Створення кластера ElastiCache (Redis)
resource "aws_elasticache_cluster" "forstep3_elasticache_cluster" {
  cluster_id          = var.cluster_id                       # Ідентифікатор кластера
  engine              = "redis"                              # Тип бази даних - Redis
  node_type           = var.node_type                        # Тип вузла, наприклад, cache.t2.micro
  num_cache_nodes     = var.num_cache_nodes                  # Кількість вузлів у кластері
  subnet_group_name   = aws_elasticache_subnet_group.forstep_aws_elasticache_subnet_group.name  # Група підмереж для кластера
  security_group_ids  = [var.security_group_id]              # Група безпеки для контролю доступу

  tags = {
    Name = var.cluster_id                                    # Теги для ідентифікації кластера
  }
}
