#!/bin/bash

# Проверка аргумента
if [ -z "$1" ]; then
    echo "Error: please specify a folder to back up."
    echo "Usage: bash backup.sh /path/to/folder"
    exit 1
fi

# Переменные
BACKUP_DIR="$1"
TIMESTAMP=$(date +%Y-%m-%d)
BACKUP_FILE="backup_$TIMESTAMP.tar.gz"

# Создание резервной копии
tar -czf "$BACKUP_FILE" "$BACKUP_DIR" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Backup created successfully: $BACKUP_FILE"
else
    echo "Backup failed!"
    exit 1
fi
