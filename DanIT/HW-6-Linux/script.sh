#!/usr/bin/bash

random_number=$(((RANDOM % 100) + 1 ))
attempts=0

while true; do
  if [ $attempts -eq 5 ]; then
    echo "Вибачте, у Вас закінчились спроби. Правильним числом було $random_number"
    exit 1
  fi

  ((attempts++))
  read -p "Спроба $attempts. Вгадайте число від 1 до 100: " guess

  if [ $guess -eq $random_number ]; then
    echo "Вітаємо! Ви вгадали правильне число."
    exit 0
  elif [ $guess -lt $random_number ]; then
    echo "Занадто низько."
  else
    echo "Занадто високо."
  fi
done