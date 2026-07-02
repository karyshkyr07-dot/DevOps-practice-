#!/bin/bash

# Simple backup script - archives a folder into .tar.gz

SOURCE_DIR="$1"
DATE=$(date +%Y-%m-%d)
BACKUP_NAME="backup_$DATE.tar.gz"

if [ -z "$SOURCE_DIR" ]; then
    echo "Error: please specify a folder to back up."
    echo "Usage: bash backup.sh /path/to/folder"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: folder '$SOURCE_DIR' not found."
    exit 1
fi

tar -czf "$BACKUP_NAME" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
    echo "Backup created successfully: $BACKUP_NAME"
else
    echo "Error creating backup."
    exit 1
fi
