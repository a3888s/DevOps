FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    gcc \
    && apt-get clean

WORKDIR /src

COPY requirements.txt .
COPY app.py .
COPY test_requests.py .

RUN echo "id,first_name,last_name, age" > students.csv

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

ENTRYPOINT ["sh", "-c"]
CMD ["gunicorn -w 4 -b 0.0.0.0:8000 app:app & sleep 10; python test_requests.py & sleep 120"]