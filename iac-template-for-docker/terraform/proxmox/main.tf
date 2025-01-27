terraform {
  required_version = ">= 0.13.0" # Мінімальна версія Terraform

  required_providers {
    proxmox = {
      source  = "telmate/proxmox" # Джерело провайдера для Proxmox
      version = "3.0.1-rc1"       # Версія провайдера
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url           # URL API для Proxmox
  pm_api_token_id     = var.proxmox_api_token_id      # ID токена для доступу
  pm_api_token_secret = var.proxmox_api_token_secret  # Секретний ключ токена
}

# Модуль для конфігурації Docker App Dev
module "docker_app_dev" {
  source = "./module/vm" # Шлях до модуля для створення VM

  target_node              = var.docker_app_dev_target_node  # Вузол для VM
  vmid                     = var.docker_app_dev_vmid         # Унікальний ID VM
  desc                     = var.docker_app_dev_desc         # Опис VM
  clone                    = var.docker_app_dev_clone        # Шаблон для клонування
  agent                    = var.docker_app_dev_agent        # Налаштування QEMU Agent
  os_type                  = var.docker_app_dev_os_type      # Тип ОС
  cores                    = var.docker_app_dev_cores        # Кількість ядер
  sockets                  = var.docker_app_dev_sockets      # Кількість сокетів
  memory                   = var.docker_app_dev_memory       # Обсяг оперативної пам'яті
  name                     = var.docker_app_dev_name         # Ім'я VM
  ipconfig0                = var.docker_app_dev_ipconfig0    # Мережеві налаштування
  ciuser                   = var.docker_app_dev_ciuser       # Користувач для Cloud-Init
  nameserver               = var.docker_app_dev_nameserver   # DNS сервер
  sshkeys                  = var.docker_app_dev_sshkeys      # SSH ключі
  disk_storage             = var.docker_app_dev_disk_storage # Сховище для дисків
  disk_size                = var.docker_app_dev_disk_size    # Розмір диска
  cloudinit_cdrom_storage  = var.docker_app_dev_cloudinit_cdrom_storage # Сховище Cloud-Init
  scsihw                   = var.docker_app_dev_scsihw       # Тип SCSI-контролера
  bootdisk                 = var.docker_app_dev_bootdisk     # Завантажувальний диск
}

# Модуль для конфігурації Docker App Prod
module "docker_app_prod" {
  source = "./module/vm" # Шлях до модуля для створення VM

  target_node              = var.docker_app_prod_target_node  # Вузол для VM
  vmid                     = var.docker_app_prod_vmid         # Унікальний ID VM
  desc                     = var.docker_app_prod_desc         # Опис VM
  clone                    = var.docker_app_prod_clone        # Шаблон для клонування
  agent                    = var.docker_app_prod_agent        # Налаштування QEMU Agent
  os_type                  = var.docker_app_prod_os_type      # Тип ОС
  cores                    = var.docker_app_prod_cores        # Кількість ядер
  sockets                  = var.docker_app_prod_sockets      # Кількість сокетів
  memory                   = var.docker_app_prod_memory       # Обсяг оперативної пам'яті
  name                     = var.docker_app_prod_name         # Ім'я VM
  ipconfig0                = var.docker_app_prod_ipconfig0    # Мережеві налаштування
  ciuser                   = var.docker_app_prod_ciuser       # Користувач для Cloud-Init
  nameserver               = var.docker_app_prod_nameserver   # DNS сервер
  sshkeys                  = var.docker_app_prod_sshkeys      # SSH ключі
  disk_storage             = var.docker_app_prod_disk_storage # Сховище для дисків
  disk_size                = var.docker_app_prod_disk_size    # Розмір диска
  cloudinit_cdrom_storage  = var.docker_app_prod_cloudinit_cdrom_storage # Сховище Cloud-Init
  scsihw                   = var.docker_app_prod_scsihw       # Тип SCSI-контролера
  bootdisk                 = var.docker_app_prod_bootdisk     # Завантажувальний диск
}

# Створення файлу інвентаризації для Ansible
resource "local_file" "ansible_inventory" {
  filename = "/home/a3888s/code/docker-app-project-iac-template/IaC/ansible/proxmox/inventory.ini" # Шлях до файлу

  content = <<-EOF
    [docker-app-dev]
    10.0.0.30

    [docker-app-prod]
    10.0.0.40

    [all:vars]
    ansible_user=a3888s
    ansible_ssh_private_key_file=~/.ssh/id_rsa
    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
    ansible_python_interpreter=/usr/bin/python3
  EOF
}
