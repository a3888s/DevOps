#!/bin/bash

CRT_DIR="/etc/letsencrypt/live/ftp.key4.com.ua"
CERT_FILE="$CRT_DIR/fullchain.pem"

# Перевіряємо, чи існує сертифікат
if [[ ! -f "$CERT_FILE" ]]; then
    echo "0"  # Якщо сертифіката немає, повертаємо 0
    exit 1
fi

month_map() {
    local list=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)
    local key="$1"
    for i in "${!list[@]}"; do
        if [[ "$key" == "${list[$i]}" ]]; then
            echo "$((i + 1))"
            return
        fi
    done
}

date_method() {
    local exp_date
    exp_date=$(openssl x509 -enddate -noout -in "$CERT_FILE" | cut -d= -f2)

    # Розбираємо дату
    local month day year
    month=$(echo "$exp_date" | awk '{print $1}')
    day=$(echo "$exp_date" | awk '{print $2}')
    year=$(echo "$exp_date" | awk '{print $4}')

    # Переводимо місяць у числовий формат
    month_num=$(month_map "$month")

    # Конвертуємо дати у timestamp
    end_ts=$(date -d "$year-$month_num-$day" '+%s')
    start_ts=$(date '+%s')

    # Обчислюємо залишкові дні
    remaining_days=$(( (end_ts - start_ts) / 86400 ))

    # Виводимо лише число
    echo "$remaining_days"
}

# Викликаємо функцію
date_method

