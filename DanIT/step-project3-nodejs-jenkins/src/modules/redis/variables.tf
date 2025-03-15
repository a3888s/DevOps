# Ідентифікатор кластера ElastiCache
variable "cluster_id" {}

# Список підмереж, де будуть розміщені вузли ElastiCache, зазвичай в приватних підмережах для безпеки
variable "subnet_ids" {
  type = list(string)
}

# ID групи безпеки, яка контролює доступ до кластера ElastiCache
variable "security_group_id" {}

# Тип вузла ElastiCache, який визначає обчислювальні ресурси, за замовчуванням cache.t2.micro
variable "node_type" {
  default = "cache.t2.micro"
}

# Кількість вузлів у кластері, що визначає масштабованість кластера
variable "num_cache_nodes" {
  type = number
  default = 1
}