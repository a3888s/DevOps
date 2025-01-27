# Вивід кінцевої точки (endpoint) для підключення до Redis кластера
output "redis_endpoint" {
  value = aws_elasticache_cluster.forstep3_elasticache_cluster.cache_nodes[0].address
}

# Вивід порту Redis кластера, на якому працює служба Redis
output "redis_port" {
  value = aws_elasticache_cluster.forstep3_elasticache_cluster.port
}

# Вивід ідентифікатора Redis кластера для моніторингу та управління
output "redis_cluster_id" {
  value = aws_elasticache_cluster.forstep3_elasticache_cluster.id
}

# Вивід назви групи підмереж для ElastiCache, де розміщені вузли кластера
output "redis_elasticache_subnet_group" {
  value = aws_elasticache_subnet_group.forstep_aws_elasticache_subnet_group.name
}

# Вивід ідентифікатора групи безпеки, який використовується для контролю доступу до Redis кластера
output "redis_security_grop_id" {
  value = var.security_group_id
}
