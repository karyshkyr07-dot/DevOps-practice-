#!/bin/ash

# log_parser_v2.sh - продвинутая версия

LOG_FILE="${1:-/var/log/auth.log}"
DAYS="${2:-1}"

# Проверка существования файла
if [ ! -f "$LOG_FILE" ]; then
    echo "❌ Ошибка: $LOG_FILE не найден"
    echo "Использование: $0 <path_to_log> [дни]"
    exit 1
fi

echo "================================"
echo "LOG PARSER v2.0 (ADVANCED)"
echo "================================"
echo "Файл: $LOG_FILE"
echo "Период: $DAYS дня(й)"
echo ""

# Функция для вывода секции
section() {
    echo ""
    echo "=== $1 ==="
}

section "📊 ОБЩАЯ СТАТИСТИКА"
echo "Всего записей: $(wc -l < "$LOG_FILE")"
echo "Размер: $(ls -lh "$LOG_FILE" | awk '{print $5}')"

section "❌ АНАЛИЗ ОШИБОК"
echo "Ошибки входа: $(grep -c "Failed" "$LOG_FILE")"
echo "Успешные входы: $(grep -c "Accepted" "$LOG_FILE")"
echo "Sudo команды: $(grep -c "sudo:" "$LOG_FILE")"

section "🔴 ТОП-5 IP С ОШИБКАМИ"
grep "Failed" "$LOG_FILE" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq -c | sort -rn | head -5

section "👤 ТОП-5 АТАКОВАННЫХ ПОЛЬЗОВАТЕЛЕЙ"
grep "Failed" "$LOG_FILE" | grep -o 'user [^ ]*' | cut -d' ' -f2 | sort | uniq -c | sort -rn | head -5

section "🔑 ВЫПОЛНЕННЫЕ SUDO КОМАНДЫ"
grep "sudo:" "$LOG_FILE" | grep -o 'COMMAND=[^ ]*' | cut -d= -f2 | sort | uniq -c | sort -rn | head -5

section "⏰ АКТИВНОСТЬ ПО ЧАСАМ"
grep "sshd" "$LOG_FILE" | awk '{print $2}' | cut -d: -f1 | sort | uniq -c

echo ""
echo "✅ Анализ завершён"
