# Використання базового образу NGINX з ECR
FROM public.ecr.aws/nginx/nginx:latest

# Копіювання власного конфігураційного файлу NGINX
COPY ./nginx.conf /etc/nginx/nginx.conf

# Копіювання файлу hw18.html у кореневу директорію NGINX
COPY ./hw18.html /usr/share/nginx/html/index.html

# Вказуємо новий порт (88), який буде відкрито для доступу до NGINX
EXPOSE 88

# Запуск NGINX при старті контейнера
CMD ["nginx", "-g", "daemon off;"]
