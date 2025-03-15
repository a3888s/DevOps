# Використання базового образу Python
FROM python:3.10-slim

# Встановлення робочої директорії
WORKDIR /app

# Копіювання залежностей до контейнера
COPY requirements.txt /app/requirements.txt

# Встановлення залежностей
RUN pip install --no-cache-dir -r requirements.txt

# Копіювання коду проекту до контейнера
COPY ./django_template /app

# Експортування порту для Django
EXPOSE 8000

# Команда для запуску додатку
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
