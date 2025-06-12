# Моніторинг RAID-масивів у Zabbix за допомогою ssacli та zabbix-raidstat

## Встановлення ssacli

1. Додати GPG-ключ і репозиторій HPE:

   ```bash
   curl -fsSL https://downloads.linux.hpe.com/SDR/downloads/MCP/GPG-KEY-mcp | gpg --dearmor | sudo tee /usr/share/keyrings/hpe-mcp.gpg > /dev/null
   echo "deb [signed-by=/usr/share/keyrings/hpe-mcp.gpg] https://downloads.linux.hpe.com/SDR/repo/mcp/ubuntu jammy/current non-free" | sudo tee /etc/apt/sources.list.d/hpe-mcp.list
   sudo apt update
   ```

2. Установити ssacli:

   ```bash
   sudo apt install ssacli
   ```

## Перевірка ssacli

1. Стан RAID-контролерів:

   ```bash
   ssacli ctrl all show config
   ```

2. Стан логічних і фізичних дисків:

   ```bash
   ssacli ctrl slot=1 pd all show status
   ssacli ctrl slot=1 ld all show status
   ```

## Клонування zabbix-raidstat

```bash
git clone https://github.com/ps78674/zabbix-raidstat.git
cd zabbix-raidstat
```

## Встановлення залежностей

```bash
sudo apt install build-essential golang make
```

> **Увага**: не використовуйте Snap-версію Go

## Компіляція zabbix-raidstat

```bash
CGO_ENABLED=1 make clean && make
```

Файли з'являться у каталозі `./build`.

## Установка

```bash
sudo mkdir -p /opt/raidstat
sudo cp build/* /opt/raidstat/
sudo cp zabbix/raidstat.sudoers /etc/sudoers.d/raidstat
sudo cp zabbix/userparameter_raidstat.conf /etc/zabbix/zabbix_agent2.d/
sudo systemctl restart zabbix-agent2
```

## Імпорт шаблону у Zabbix GUI

1. Відкрийте Zabbix → **Configuration → Templates**
2. Натисніть **Import** → виберіть файл `zbx_raid_monitoring.xml`
3. Призначте шаблон хосту
4. Додайте макрос хосту:

   ```
   {$RAID_VENDOR} = hp
   ```

## Основні можливості

* Автоматичне виявлення RAID-контролерів, логічних та фізичних дисків
* Підтримка різних виробників: HP (ssacli), Adaptec (arcconf), MegaCLI, mvcli, sas2ircu
* Моніторинг статусів: battery, cache, SMART
* Підтримка тригерів і повідомлень
* Лігка і швидка інтеграція з Zabbix Agent 2

---

Підтримка: [https://github.com/ps78674/zabbix-raidstat](https://github.com/ps78674/zabbix-raidstat)
