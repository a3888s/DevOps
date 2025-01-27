# Назва для VPC, що використовується для ідентифікації ресурсу
variable "vpc_name" {}

# CIDR блок для основної мережі VPC, що визначає діапазон IP-адрес
variable "vpc_cidr_block" {}

# CIDR блок для першої публічної підмережі в VPC
variable "public_subnet_sidr_1" {}

# CIDR блок для другої публічної підмережі в VPC
variable "public_subnet_sidr_2" {}

# CIDR блок для першої приватної підмережі в VPC
variable "private_subnet_sidr_1" {}

# CIDR блок для другої приватної підмережі в VPC
variable "private_subnet_sidr_2" {}

# Перша зона доступності, де буде створена частина підмереж
variable "availability_zone_1" {}

# Друга зона доступності для розподілу підмереж та забезпечення високої доступності
variable "availability_zone_2" {}

# Список портів, які будуть відкриті в групі безпеки для доступу до інстансів
variable "list_of_open_ports" {}

# Теги для VPC, які додають метаінформацію для зручного управління ресурсами
variable "vpc_tag" {}
