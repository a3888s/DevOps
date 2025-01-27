# File: modules/rds/outputs.tf

output "db_endpoint" {
  description = "Endpoint для підключення до RDS бази даних"
  value       = aws_db_instance.forstep_db_instance.endpoint
}

output "db_port" {
  description = "Порт для RDS бази даних"
  value       = aws_db_instance.forstep_db_instance.port
}

output "db_instance_id" {
  description = "Ідентифікатор RDS інстанса"
  value       = aws_db_instance.forstep_db_instance.id
}

output "db_subnet_group" {
  description = "Назва підмережної групи для RDS"
  value       = aws_db_subnet_group.forstep_db_subnet_group.name
}