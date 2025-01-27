variable "target_node" {
  # Вузол Proxmox, на якому буде створено віртуальну машину
}

variable "vmid" {
  # Унікальний ідентифікатор віртуальної машини
}

variable "desc" {
  # Опис віртуальної машини
}

variable "clone" {
  # Шаблон, з якого буде клонуватися віртуальна машина
}

variable "agent" {
  # Стан QEMU Guest Agent (0 = вимкнено, 1 = увімкнено)
}

variable "os_type" {
  # Тип операційної системи
}

variable "cores" {
  # Кількість ядер процесора
}

variable "sockets" {
  # Кількість сокетів процесора
}

variable "memory" {
  # Обсяг оперативної пам'яті в МБ
}

variable "name" {
  # Ім'я віртуальної машини
}

variable "ipconfig0" {
  # Мережеві налаштування в форматі Cloud-Init (IP, шлюз)
}

variable "ciuser" {
  # Ім'я користувача для Cloud-Init
}

variable "nameserver" {
  # DNS-сервер для віртуальної машини
}

variable "sshkeys" {
  # SSH ключі для доступу до віртуальної машини
}

variable "disk_storage" {
  # Сховище для дисків віртуальної машини
}

variable "disk_size" {
  # Розмір диска в ГБ
}

variable "cloudinit_cdrom_storage" {
  # Сховище для Cloud-Init CD-ROM
}

variable "scsihw" {
  # Тип контролера SCSI
}

variable "bootdisk" {
  # Завантажувальний диск
}
