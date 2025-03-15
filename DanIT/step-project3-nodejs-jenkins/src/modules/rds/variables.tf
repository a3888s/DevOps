variable "db_name" {
  description = "Назва бази даних"
  type        = string
}

variable "username" {
  description = "Ім'я користувача бази даних"
  type        = string
}

variable "password" {
  description = "Пароль для користувача бази даних"
  type        = string
}

variable "subnet_ids" {
  description = "Список підмереж для RDS"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID групи безпеки для RDS"
  type        = string
}

variable "instance_class" {
  description = "Клас інстансу для RDS"
  type        = string
}

variable "allocated_storage" {
  description = "Розмір дискового простору для RDS (ГБ)"
  type        = number
  default     = 20
}

variable "backup_retention_period" {
  description = "Кількість днів для зберігання резервних копій RDS"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Вікно для резервного копіювання RDS"
  type        = string
  default     = "02:00-03:00"
}

variable "monitoring_interval" {
  description = "Інтервал моніторингу для CloudWatch (у секундах)"
  type        = number
  default     = 60
}