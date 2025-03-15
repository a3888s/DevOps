#Реалізація багатоступеневої збірки (multi-stage builds) у Dockerfile
# Етап 1: Білд (Builder)
FROM python:3.10-slim AS builder

# Встановлення необхідних залежностей для збірки
RUN apt-get update && apt-get install -y --no-install-recommends gcc

# Робоча директорія для збірки
WORKDIR /app

# Копіюємо тільки необхідні файли для встановлення залежностей
COPY requirements.txt .

# Встановлюємо залежності в окрему директорію
RUN pip install --prefix=/install -r requirements.txt

# Етап 2: Фінальний образ
FROM python:3.10-slim

# Встановлюємо залежності з попереднього етапу
COPY --from=builder /install /usr/local

# Робоча директорія для додатка
WORKDIR /app

# Копіюємо код додатка
COPY app.py .

# Відкриваємо порт для роботи додатка
EXPOSE 8080

# Команда для запуску додатка
CMD ["python", "app.py"]
