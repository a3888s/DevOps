# Моніторинг SSL-сертифікатів у Zabbix

## Огляд

Ця конфігурація дозволяє моніторити термін дії SSL-сертифіката для `site.com.ua` за допомогою Zabbix. Скрипт визначає кількість днів до закінчення сертифіката та активує тригер, якщо термін дії наближається до завершення.

## Встановлення

### 1. Копіювання скрипта моніторингу

Збережіть наступний скрипт у `/usr/local/bin/check_ssl_expiry.sh` та зробіть його виконуваним:

```sh
sudo chmod +x /usr/local/bin/check_ssl_expiry.sh
```

### 2. Налаштування Zabbix Agent

Відредагуйте конфігураційний файл Zabbix Agent (`/etc/zabbix/zabbix_agentd.conf`) і додайте:

```ini
UserParameter=ssl.cert_exp_days,/usr/local/bin/check_ssl_expiry.sh
```

Перезапустіть Zabbix Agent:

```sh
sudo systemctl restart zabbix-agent
```

### 3. Надання доступу до сертифікатів

Якщо потрібно, надайте користувачу `zabbix` доступ до сертифікатів Let's Encrypt, додавши його до групи `ssl-cert`:

```sh
sudo groupadd ssl-cert
sudo usermod -aG ssl-cert zabbix
sudo chown -R root:ssl-cert /etc/letsencrypt
sudo chmod -R 750 /etc/letsencrypt
```

### 4. Оновити сесію Zabbix

Щоб зміни набули чинності, перезапустіть Zabbix Agent:

```sh
sudo systemctl restart zabbix-agent
```

Або примусово оновіть групи користувача `zabbix` без перезапуску:

```sh
sudo su - zabbix -s /bin/bash
```

Та перевірте доступ:

```sh
ls -lah /etc/letsencrypt/live/ftp.key4.com.ua/fullchain.pem
```

Якщо видно файл без `Permission denied` – все працює.

### 5. Перевір виконання скрипта від імені zabbix

Щоб переконатися, що `zabbix` тепер має доступ:

```sh
sudo -u zabbix /usr/local/bin/check_ssl_expiry.sh
```

Якщо повертається число (наприклад, `89`), доступ налаштовано правильно.
Якщо `Permission denied`, перевірте ще раз права доступу.

### 6. Перевірка роботи скрипта

Запустіть команду:

```sh
/usr/local/bin/check_ssl_expiry.sh
```

Очікуваний вивід: число, що вказує кількість днів до завершення терміну дії сертифіката.

Перевірте отримання значення через Zabbix:

```sh
zabbix_get -s <server_ip> -k ssl.cert_exp_days
```

## Налаштування тригера в Zabbix

### Імпорт шаблону

Щоб спростити налаштування, імпортуйте готовий шаблон `check-ssl.yaml` у Zabbix.