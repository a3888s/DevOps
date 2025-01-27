# Налаштування AWS VPC з публічними та приватними підмережами

### 1. Створити VPC

1. Створив **VPC**:
   - **Назва**: `HW17VPC`
   - **IPv4 CIDR block**: `10.100.0.0/16`
![Фото 1](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/1.png)


### 2. Створити підмережі

#### Публічна підмережа

1. Створив **Public Subnet**:
   - **VPC**: `HW17VPC`
   - **Назва підмережі**: `HW17PublicSubnet`
   - **CIDR block**: `10.100.200.0/24`
![Фото 2](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/5.png)

#### Приватна підмережа

1. Створив **Private Subnet**:
   - **VPC**: `HW17VPC`
   - **Назва підмережі**: `HW17PrivateSubnet`
   - **CIDR block**: `10.100.100.0/24`
![Фото 3](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/4.png)

### 3. Інтернет-шлюз

1. Створив **Internet Gateways**
   - **Назва**: `HW17InternetGateway`
2. Прикріпив Інтернет-шлюз до `HW17VPC`.
![Фото 4](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/2.png)

### 4. NAT-шлюз

1. Створив **NAT gateway**
   - **Назва**: `HW17NATGateway`
   - **Elastic IP**: Виділив нову IP-адресу.
2. Прикріпив до `HW17PublicSubnet`.
![Фото 5](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/3.png)

### 5. Оновив таблиці маршрутизації

#### Таблиця маршрутів для публічної підмережі

1. Змінив **Routes** для **HW17PublicRoute**:
   - **Призначення**: `0.0.0.0/0`
   - **Ціль**: `HW17InternetGateway`
![Фото 6](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/6.png)

#### Таблиця маршрутів для приватної підмережі

Щоб дозволити EC2 **HW17PrivateEC2** у приватній підмережі доступ до інтернету:
1. Змінив **Routes** для **HW17PrivateRoute**:
   - **Призначення**: `0.0.0.0/0`
   - **Ціль**: `HW17NATGateway`
![Фото 7](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/7.png)

### 6. Запуск екземплярів EC2

#### Публічний екземпляр EC2

1. Запустив екземпляр EC2 **HW17PublicEC2** у підмережі `HW17PublicSubnet`.
![Фото 8](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/8.png)

#### Приватний екземпляр EC2

1. Запустив екземпляр EC2 **HW17PrivateEC2** у підмережі `HW17PrivateSubnet`.
![Фото 9](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/10.png)

### 7. Підключення через SSH

1. Підключіться до **HW17PublicEC2** за допомогою його публічної IP-адреси.
![Фото 10](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/9.png)

2. З публічного екземпляра підключаюсь до **HW17PrivateEC2** за допомогою його приватної IP-адреси.
![Фото 11](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/11.png)
![Фото 12](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/12.png)
![Фото 13](https://gitlab.com/my_dan.it/my_danit_lesson/-/raw/main/0_DZ/HW-17/screens/13.png)