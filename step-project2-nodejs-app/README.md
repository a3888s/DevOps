# Посібник зі встановлення Jenkins та виконання Pipeline

## 1. Встановлення Jenkins за допомогою Vagrant

Клонуйте репозиторій і запустіть середовище Vagrant:
```bash
git clone https://gitlab.com/my_dan.it/forstep2.git
cd forStep2
vagrant up
```

## 2. Налаштування Jenkins Worker

SSH на Jenkins worker і налаштуйте середовище:
```bash
cd forStep2
vagrant ssh jenkins-worker
cd /opt
sudo mkdir jenkins
sudo chown vagrant:vagrant jenkins/
cd jenkins
curl -sO http://10.0.0.78:8080/jnlpJars/agent.jar
nohup java -jar agent.jar -url <YOUR_IP> -secret <YOUR_SECRET> -name <YOUR_NAME> -workDir "/opt/jenkins" > jenkins_agent.log 2>&1 &
```
Замість `<YOUR_SECRET>` `<YOUR_IP>` `<YOUR_NAME>` вставте дані, наданий вашим сервером Jenkins.

## 3. Налаштування Jenkins Server

1. Встановіть необхідні плагіни та налаштуйте відповідні дозволи.
2. Переконайтеся, що всі залежності правильно встановлені для сервера Jenkins.

## 4. Створення та запуск Jenkins Pipeline

1. Перейдіть на панель керування вашого сервера Jenkins.
2. Створіть нову роботу типу Pipeline.
3. У скрипті Pipeline вкажіть шлях до фалу Jenkinsfile
4. Запустіть pipeline та слідкуйте за виконанням.

## Додаткові примітки

- Переконайтеся, що Jenkins worker правильно зареєстрований і підключений до сервера Jenkins.
- Перевірте логи (`jenkins_agent.log`) у разі виникнення проблем з worker.