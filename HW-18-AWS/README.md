# Виконання завдання HW18 з використанням AWS

## 1. Створення репозиторію ECR
1. Створив **Elastic Container Registry (ECR)** репозиторій:
   - **Назва репозиторію**: `hw18-a3888s`
   ![Фото 1](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-18/screens/1.png?ref_type=heads)

## 2. Завантаження Docker-образу
1. Створив Dockerfile з використанням базового образу NGINX з репозиторію ECR.
   - Змінив порт на 88 та додав власний `nginx.conf` для налаштування сервера.
   - Скопіював файл `hw18.html` у папку NGINX для відображення сторінки.
   ![Фото 2](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-18/screens/2.png?ref_type=heads)
   
2. Виконав команди для завантаження образу в репозиторій ECR:
   ```bash
   docker pull 050451375060.dkr.ecr.us-east-1.amazonaws.com/hw18-a3888s:latest
   docker run -d -p 88:88 050451375060.dkr.ecr.us-east-1.amazonaws.com/hw18-a3888s:latest
   ```
   ![Фото 3](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-18/screens/3.png?ref_type=heads)

3. Перевірив сторінку, яка доступна на `http://10.0.0.77:88`, де відображається тема завдання HW18.
   ![Фото 4](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-18/screens/4.png?ref_type=heads)

## 3. Створення EC2 екземпляра
1. Створив екземпляр EC2 під назвою `hw18-bastion` у підмережі.
   ![Фото 7](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-18/screens/6.png?ref_type=heads)
   
2. Створив екземпляр **HW18LamdaEC2**, який буде використовуватись для запуску та зупинки через Lambda функцію.
   ![Фото 8](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-18/screens/8.png?ref_type=heads)

## 4. Створення бази даних RDS
1. Створив базу даних **Amazon RDS MySQL**:
   - **Ідентифікатор бази даних**: `hw18db`
   - **Тип екземпляру**: `db.t4g.micro`
   ![Фото 5](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-18/screens/5.png?ref_type=heads)
   
2. Підключився до бази даних через MySQL CLI, використовуючи кінцеву точку:
   ```bash
   mysql -h hw18db.cxwaok8k2emf.us-east-1.rds.amazonaws.com -u hw18 -p
   ```
   ![Фото 6](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-18/screens/7.png?ref_type=heads)

## 5. Створення Lambda функції для зупинки EC2
1. Створив Lambda-функцію `HW18LamdaPython`, яка перевіряє інстанси EC2 з тегом `HW18LamdaEC2` і зупиняє їх.
   - Використано бібліотеку boto3 для взаємодії з AWS EC2.
   ![Фото 9](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-18/screens/9.png?ref_type=heads)

## 6. Налаштування розкладу для Lambda через Amazon EventBridge
1. Налаштував розклад через Amazon EventBridge для запуску Lambda функції щодня о 22:55 за часом Києва (UTC+3).
   ![Фото 10](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-18/screens/10.png?ref_type=heads)

2. Перевірив логи виконання функції через CloudWatch:
   - Логи показують, що функція успішно зупинила екземпляр `HW18LamdaEC2`.
   ![Фото 11](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-18/screens/11.png?ref_type=heads)