#!/bin/bash
# Bash scripting

###Exercise 1: Hello World
####Напишіть сценарій Bash, який просто повторює "Hello, World!" при виконанні.
#echo "Hello World"
#
###Exercise 2: User Input
####Створіть сценарій, який запитує в користувача ім’я, а потім вітає його, використовуючи це ім’я.
#read -p "Введіть Ваше ім'я: " name
#echo "Привіт ${name}"
#
###Exercise 3: Conditional Statements
####Напишіть сценарій, який перевіряє, чи існує файл у поточному каталозі. Якщо так, надрукуйте повідомлення про його
####існування; інакше надрукуйте повідомлення про те, що його не існує.
#if [ -e "dz.sh" ]; then
#  echo "Файл 'dz.sh' існує."
#else
#  echo "Файл 'dz.sh' не існує."
#fi
#
###Exercise 4: Looping
####Створіть сценарій, який використовує цикл для друку чисел від 1 до 10.
#for (( i=0; i<10; i++ )); do
#  echo $i
#done
#
###Exercise 5: File Operations
####Напишіть сценарій, який копіює файл з одного місця в інше. Обидва розташування слід передати як аргументи
#PATH1=/home/a3888s/my_danit_lesson/0_DZ/HW-2/DZ_FO1/
#PATH2=/home/a3888s/my_danit_lesson/0_DZ/HW-2/DZ_FO2/
#
#if [ -e "${PATH1}/test_copy.txt" ]; then
#  cp "${PATH1}/test_copy.txt" "${PATH2}"
#  echo "Файл test_copy.txt успішно скопійовано"
#else
#  echo "Файл test_copy.txt не існує"
#fi
#
#
###xercise 6: String Manipulation
####Створіть сценарій, який приймає введені користувачем дані як речення, а потім перевертає речення слово за словом
####(наприклад, «Hello World» стає «World Hello»).
#read -p "Введіть речення: " sentence
#words=($sentence)
#num_words=${#words[@]}
#reversed_sentence=""
#
#for (( i=$num_words-1; i>=0; i-- )); do
#    reversed_sentence="${reversed_sentence} ${words[i]}"
#done
#
#echo "Результат: ${reversed_sentence}"


##Exercise 7: Command Line Arguments
###Розробіть сценарій, який приймає назву файлу як аргумент командного рядка та друкує кількість рядків у цьому файлі.
#if [ "$#" -ne 1 ]; then
#  echo "Введіть: $0/назва_файлу"
#  exit 1
#fi
#
#filename="$1"
#
#if [ ! -f "$filename" ]; then
#  echo "Файл $filename не існує"
#  exit 1
#fi
#
#line_count=$(wc -l < "$filename")
#echo "Кількість рядків у файлі $filename: $line_count"


##Exercise 8: Arrays
###Напишіть сценарій, який використовує масив для зберігання списку фруктів. Перегляньте масив і виведіть кожен фрукт в
###окремому рядку.
#fruits=("Яблуко" "Банан" "Апельсин" "Груша" "Виноград")
#for fruit in "${fruits[@]}"; do
#  echo "$fruit"
#done


##Exercise 9: Error Handling
###Розробіть сценарій, який намагається прочитати файл і акуратно обробляє помилки. Якщо файл існує, він повинен
###вивести його вміст; якщо ні, має відобразитися повідомлення про помилку.
#if [ "$#" -ne 1 ]; then
#  echo "Введіть: $0/назва_файлу"
#  exit 1
#fi
#
#filename="$1"
#
#if [ -f "$filename" ]; then
#  if [ -r "$filename" ]; then
#    echo "Вміст файлу $filename:"
#    cat "$filename"
#  else
#    echo "Файл $filename не є читабельним."
#    exit 1
#  fi
#else
#  echo "Файл filename не існує."
#  exit 1
#fi

# Systemd service

##Напишіть сценарій, який переглядає каталог "~/watch". Якщо він бачить, що з’явився новий файл, він друкує вміст
# файлу та перейменовує його на *.back

##Напишіть службу SystemD для цього сценарію та запустіть її

#WATCH_DIR="/home/a3888s/my_danit_lesson/0_DZ/HW-2/watch"
#
#if [ ! -d "$WATCH_DIR" ]; then
#  echo "Директорія $WATCH_DIR не існує." >&2
#  exit 1
#fi
#
#if ! command -v inotifywait &> /dev/null; then
#  echo "inotifywait не знайдено, будь ласка, встановіть inotify-tools." >&2
#  exit 1
#fi
#
#echo "Запуск моніторингу каталогу $WATCH_DIR..."
#
#while true; do
#  FILE=$(inotifywait -q --format '%f' -e create "$WATCH_DIR")
#
#  FILE_PATH="$WATCH_DIR/$FILE"
#
#  if [ -f "$FILE_PATH" ]; then
#    echo "Новий файл: $FILE"
#    cat "$FILE_PATH"
#    mv "$FILE_PATH" "$FILE_PATH.back"
#    sleep 0.1
#  fi
#done





