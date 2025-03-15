#!/bin/bash
# Оновлюємо список пакетів
apt-get update -y

# Встановлюємо веб-сервер Nginx
apt-get install nginx -y

# Запускаємо Nginx
systemctl start nginx

# Включаємо Nginx для автоматичного запуску при завантаженні системи
systemctl enable nginx
