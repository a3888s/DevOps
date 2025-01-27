FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
RUN apt update -qq && apt install -y -qq curl

COPY . .

EXPOSE 5000

ENTRYPOINT [ "python3", "app.py" ]