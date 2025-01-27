terraform {
  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox" # Джерело провайдера для роботи з Proxmox
      version = "3.0.1-rc1"       # Версія провайдера
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  target_node = var.target_node       # Вузол Proxmox, де буде створено VM
  vmid        = var.vmid              # Унікальний ідентифікатор для VM
  desc        = var.desc              # Опис VM
  clone       = var.clone             # Шаблон для клонування
  agent       = var.agent             # Стан QEMU Guest Agent (0 = вимкнено, 1 = увімкнено)
  os_type     = var.os_type           # Тип операційної системи
  cores       = var.cores             # Кількість ядер процесора
  sockets     = var.sockets           # Кількість сокетів процесора
  memory      = var.memory            # Обсяг оперативної пам'яті (у МБ)
  name        = var.name              # Ім'я VM
  ipconfig0   = var.ipconfig0         # Мережеві налаштування (IP, шлюз)
  ciuser      = var.ciuser            # Користувач для Cloud-Init
  nameserver  = var.nameserver        # DNS сервер
  sshkeys     = var.sshkeys           # SSH ключі для доступу

  disks {
    scsi {                            # Конфігурація SCSI-дисків
      scsi0 {
        disk {
          storage = var.disk_storage  # Сховище для дисків
          size    = var.disk_size     # Розмір диска (у ГБ)
        }
      }
    }
  }

  cloudinit_cdrom_storage = var.cloudinit_cdrom_storage # Сховище для Cloud-Init
  scsihw                  = var.scsihw                 # Тип контролера SCSI
  bootdisk                = var.bootdisk               # Завантажувальний диск
}
