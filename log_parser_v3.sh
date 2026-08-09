#!/bin/ash

# log_parser_v3.sh - с экспортом результатов

LOG_FILE="${1:-/var/log/auth.log}"
REPORT_FILE="report_$(date +%Y%m%d_%H%M%S).txt"

if [ ! -f "$LOG_FILE" ]; then
    echo "❌ Ошибка: $LOG_FILE не найден"
    exit 1
fi

# Создаём отчёт
{
    echo "================================"
    echo "LOG PARSER REPORT"
    echo "Дата: $(date)"
    echo "Файл: $LOG_FILE"
    echo "================================"
    echo ""

    echo "📊 ОБЩАЯ СТАТИСТИКА"
    echo "Всего записей: $(wc -l < "$LOG_FILE")"
    echo "Размер: $(ls -lh "$LOG_FILE" | awk '{print $5}')"
    echo ""

    echo "❌ АНАЛИЗ ОШИБОК"
    echo "Ошибки входа: $(grep -c "Failed" "$LOG_FILE")"
    echo "Успешные входы: $(grep -c "Accepted" "$LOG_FILE")"
    echo "Sudo команды: $(grep -c "sudo:" "$LOG_FILE")"
    echo ""

    echo "🔴 ТОП-5 IP С ОШИБКАМИ"
    grep "Failed" "$LOG_FILE" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq -c | sort -rn | head -5
    echo ""

    echo "👤 ТОП-5 АТАКОВАННЫХ ПОЛЬЗОВАТЕЛЕЙ"
    grep "Failed" "$LOG_FILE" | grep -o 'user [^ ]*' | cut -d' ' -f2 | sort | uniq -c | sort -rn | head -5
    echo ""

    echo "🔑 ВЫПОЛНЕННЫЕ SUDO КОМАНДЫ"
    grep "sudo:" "$LOG_FILE" | grep -o 'COMMAND=[^ ]*' | cut -d= -f2 | sort | uniq -c | sort -rn | head -5
    echo ""

    echo "⏰ АКТИВНОСТЬ ПО ЧАСАМ"
    grep "sshd" "$LOG_FILE" | awk '{print $2}' | cut -d: -f1 | sort | uniq -c
    echo ""

    echo "✅ Отчёт создан: $(date)"

} > "$REPORT_FILE"

# Показываем на экран и в файл одновременно
cat "$REPORT_FILE"
echo ""
echo "💾 Отчёт сохранён: $REPORT_FILE"
