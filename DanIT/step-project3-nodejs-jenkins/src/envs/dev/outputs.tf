# Вивід VPC ID
output "vpc_id" {
  value = module.vpc.vpc_id
}

# Вивід публічної IP-адреси для on-demand EC2 (Jenkins Master)
output "on_demand_ec2_ip" {
  value = module.on_demand_ec2.instance_public_ips
}

output "autoscaling_instance_public_ips" {
  value       = data.aws_instances.asg_instances.public_ips
  description = "Список публічних IP-адрес інстансів Auto Scaling Group"
}

# Вивід приватної IP-адреси для spot EC2 інстансів
output "spot_ec2_ip" {
  value = module.spot_ec2.instance_private_ips
}

# Вивід для RDS
output "rds_endpoint" {
  description = "Endpoint для підключення до RDS бази даних"
  value       = module.rds.db_endpoint
}

output "rds_port" {
  description = "Порт для RDS бази даних"
  value       = module.rds.db_port
}

output "rds_instance_id" {
  description = "Ідентифікатор RDS інстанса"
  value       = module.rds.db_instance_id
}

# Вивід для Redis
output "redis_endpoint" {
  description = "Endpoint для підключення до кластера Redis"
  value       = module.redis.redis_endpoint
}

output "redis_port" {
  description = "Порт для Redis кластера"
  value       = module.redis.redis_port
}

output "redis_cluster_id" {
  description = "Ідентифікатор кластера Redis"
  value       = module.redis.redis_cluster_id
}

# Вивід DNS і параметрів Load Balancer
output "load_balancer_dns" {
  description = "DNS ім'я для підключення до Load Balancer"
  value       = module.lb.lb_dns
}

output "load_balancer_arn" {
  description = "ARN Load Balancer"
  value       = module.lb.lb_arn
}

# Вивід Target Group
output "target_group_arn" {
  description = "ARN цільової групи для Load Balancer"
  value       = module.lb.target_group_arn
}