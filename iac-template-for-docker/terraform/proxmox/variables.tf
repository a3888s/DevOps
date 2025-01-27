variable "proxmox_api_url" {
  type = string
  # URL для підключення до API Proxmox
}

variable "proxmox_api_token_id" {
  type = string
  # Ідентифікатор токена для доступу до API Proxmox
}

variable "proxmox_api_token_secret" {
  type = string
  # Секретний ключ токена для доступу до API Proxmox
}

# Змінні для Docker App Dev
variable "docker_app_dev_target_node" {
  # Вузол Proxmox, на якому буде розміщено VM
}

variable "docker_app_dev_vmid" {
  # Унікальний ідентифікатор віртуальної машини
}

variable "docker_app_dev_desc" {
  # Опис віртуальної машини
}

variable "docker_app_dev_clone" {
  # Шаблон, з якого буде клонуватися VM
}

variable "docker_app_dev_agent" {
  # Стан QEMU Agent (0 - вимкнено, 1 - увімкнено)
}

variable "docker_app_dev_os_type" {
  # Тип операційної системи
}

variable "docker_app_dev_cores" {
  # Кількість ядер процесора
}

variable "docker_app_dev_sockets" {
  # Кількість сокетів процесора
}

variable "docker_app_dev_memory" {
  # Обсяг оперативної пам’яті в МБ
}

variable "docker_app_dev_name" {
  # Ім'я віртуальної машини
}

variable "docker_app_dev_ipconfig0" {
  # Мережеві налаштування (IP, шлюз)
}

variable "docker_app_dev_ciuser" {
  # Користувач для Cloud-Init
}

variable "docker_app_dev_nameserver" {
  # DNS-сервер
}

variable "docker_app_dev_sshkeys" {
  # SSH ключі для доступу
}

variable "docker_app_dev_disk_storage" {
  # Сховище для дисків
}

variable "docker_app_dev_disk_size" {
  # Розмір диска в ГБ
}

variable "docker_app_dev_cloudinit_cdrom_storage" {
  # Сховище для Cloud-Init CD-ROM
}

variable "docker_app_dev_scsihw" {
  # Тип контролера SCSI
}

variable "docker_app_dev_bootdisk" {
  # Завантажувальний диск
}

# Змінні для Docker App Prod
variable "docker_app_prod_target_node" {
  # Вузол Proxmox, на якому буде розміщено VM
}

variable "docker_app_prod_vmid" {
  # Унікальний ідентифікатор віртуальної машини
}

variable "docker_app_prod_desc" {
  # Опис віртуальної машини
}

variable "docker_app_prod_clone" {
  # Шаблон, з якого буде клонуватися VM
}

variable "docker_app_prod_agent" {
  # Стан QEMU Agent (0 - вимкнено, 1 - увімкнено)
}

variable "docker_app_prod_os_type" {
  # Тип операційної системи
}

variable "docker_app_prod_cores" {
  # Кількість ядер процесора
}

variable "docker_app_prod_sockets" {
  # Кількість сокетів процесора
}

variable "docker_app_prod_memory" {
  # Обсяг оперативної пам’яті в МБ
}

variable "docker_app_prod_name" {
  # Ім'я віртуальної машини
}

variable "docker_app_prod_ipconfig0" {
  # Мережеві налаштування (IP, шлюз)
}

variable "docker_app_prod_ciuser" {
  # Користувач для Cloud-Init
}

variable "docker_app_prod_nameserver" {
  # DNS-сервер
}

variable "docker_app_prod_sshkeys" {
  # SSH ключі для доступу
}

variable "docker_app_prod_disk_storage" {
  # Сховище для дисків
}

variable "docker_app_prod_disk_size" {
  # Розмір диска в ГБ
}

variable "docker_app_prod_cloudinit_cdrom_storage" {
  # Сховище для Cloud-Init CD-ROM
}

variable "docker_app_prod_scsihw" {
  # Тип контролера SCSI
}

variable "docker_app_prod_bootdisk" {
  # Завантажувальний диск
}
