#!/bin/bash

threshold=90
usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ $usage -gt $ threshold ]; then
  echo "$(date +"%Y-%m-%d %H:%M:%S") - Попередження: Використання кореневої файлової системи перевищує $threshold%" >> /var/log/disk.log
fi