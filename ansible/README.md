# 🛠️ Ansible: Автоматичне налаштування серверів

Цей проєкт допоможе швидко налаштовувати сервери Ubuntu, Debian та Windows за допомогою Ansible. Він організований так, щоб легко розширювати й адаптувати для різних операційних систем.

---

## 📁 Структура проєкту

```
ansible/
├── client/
│   └── client1-setup/
│       ├── inventory.yml
│       ├── group_vars/
│       │   └── all.yml
│       └── playbook/
│           ├── ubuntu/
│           │   ├── ansible.cfg
│           │   └── update_and_configure.yml
│           ├── debian/
│           │   ├── ansible.cfg
│           │   └── update_and_configure.yml
│           └── windows/
│               ├── ansible.cfg
│               └── base.yml
├── template/
│   ├── nix/
│   │   ├── playbook/
│   │   │   └── update_and_configure.yml
│   │   └── roles/
│   │       ├── ubuntu/
│   │       │   ├── 01-common/
│   │       │   │   └── tasks/
│   │       │   │       └── main.yml
│   │       │   ├── 02-timezone/
│   │       │   ├── 03-hostname/
│   │       │   ├── 04-users/
│   │       │   ├── 05-ssh/
│   │       │   ├── 06-zabbix/
│   │       │   ├── 07-fail2ban/
│   │       │   ├── 08-iptables/
│   │       │   └── 09-ipv6/
│   │       └── debian/
└── windows/
    ├── playbook/
    │   └── base.yml
    └── roles/
        └── win_common/
```

---

## 🗂️ Файл `inventory.yml`

`inventory.yml` — файл, у якому описані сервери (хости), до яких Ansible буде підключатися. У ньому можна створювати групи хостів, задавати IP-адреси, логіни, паролі, порти та типи з'єднання.

Приклад структури `inventory.yml`:

```yaml
all:
  children:
    setup:
      hosts:
        clikchouse-mv:
          ansible_host: 10.10.10.10
          ansible_password: password
      vars:
        ansible_user: root
        ansible_port: 22
        ansible_connection: ssh
```

Цей файл дозволяє централізовано керувати підключеннями до серверів.

---

## 🔨 Як створити роль

`roles/ubuntu/01-common/` — одна з ролей, що містить типові задачі для кожного сервера (оновлення, встановлення утиліт). Основний файл — `tasks/main.yml` — містить перелік команд, які виконуються в межах цієї ролі. Наприклад:

```bash
cd template/nix/roles/ubuntu
ansible-galaxy init 10-newrole
```

📌 Замість `10-newrole` вкажіть потрібну назву. Цифра на початку допомагає впорядкувати ролі за черговістю виконання.

Приклад вмісту `main.yml`:

```yaml
- name: Update package index and upgrade packages
  apt:
    update_cache: yes
    upgrade: yes
```

---

## ✍️ Як написати плейбук

```yaml
# client/client1-setup/playbook/ubuntu/update_and_configure.yml
- name: Оновлення та налаштування серверів
  hosts: all
  become: yes
  vars_files:
    - ../../group_vars/all.yml
  roles:
    - { role: 01-common, tags: ["common"] }
    - { role: 02-timezone, tags: ["timezone"] }
    - { role: 03-hostname, tags: ["hostname"] }
    - { role: 04-users, tags: ["users"] }
    - { role: 05-ssh, tags: ["ssh"] }
    - { role: 06-zabbix, tags: ["zabbix"] }
    - { role: 07-fail2ban, tags: ["fail2ban"] }
    - { role: 08-iptables, tags: ["iptables"] }
    - { role: 09-ipv6, tags: ["ipv6"] }
```

---

## 🧩 Файл змінних `group_vars/all.yml`

Файл `all.yml` у каталозі `group_vars` зберігає спільні змінні для всіх хостів. Його вміст може виглядати так:

```yaml
users:
  - { name: "user1", password: "password" }
  - { name: "user2", password: "password" }

hostnames:
  server1: "hostname"

zabbix_server: "10.10.10.11"
ssh_port: 22126
```

Цей підхід дозволяє централізувати параметри, які можуть використовуватись у кількох плейбуках та ролях. Це підвищує читабельність і спрощує підтримку конфігурацій.

---

## ⚙️ Як налаштувати ansible.cfg

```ini
# client/client1-setup/playbook/ubuntu/ansible.cfg
[defaults]
roles_path = /home/a3888s/ansible/template/nix/roles/ubuntu
inventory = ../../inventory.yml
```

---

## 🚀 Як запустити playbook

```bash
cd client/client1-setup/playbook/ubuntu
ansible-playbook update_and_configure.yml -vv
```

Або для запуску лише певних частин:

```bash
ansible-playbook update_and_configure.yml --tags "firewall,users"
```

---

## 🔁 Як адаптувати для інших систем

Для Debian чи Windows:

* Створіть ролі в `template/nix/roles/debian/` або `template/roles/windows/`
* Додайте відповідний плейбук до `client/client1-setup/playbook/{debian|windows}/`
* Створіть окремий `ansible.cfg` з відповідним `roles_path`

