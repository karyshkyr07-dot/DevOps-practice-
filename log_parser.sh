#!/bin/ash

LOG_FILE="/var/log/auth.log"

echo "================================"
echo "LOG PARSER v1.0"
echo "================================"
echo ""

echo "📊 ВСЕГО ЗАПИСЕЙ:"
wc -l < "$LOG_FILE"
echo ""

echo "❌ ОШИБОК ВХОДА:"
grep "Failed" "$LOG_FILE" | wc -l
echo ""

echo "✅ УСПЕШНЫХ ВХОДОВ:"
grep "Accepted" "$LOG_FILE" | wc -l
echo ""

echo "🔴 ТОП IP АДРЕСОВ С ОШИБКАМИ:"
grep "Failed" "$LOG_FILE" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq -c | sort -rn
echo ""

echo "👤 АТАКОВАННЫЕ ПОЛЬЗОВАТЕЛИ:"
grep "Failed" "$LOG_FILE" | grep -o 'user [^ ]*' | cut -d' ' -f2 | sort | uniq -c | sort -rn
echo ""

echo "🔑 SUDO КОМАНДЫ:"
grep "sudo:" "$LOG_FILE" | grep -o 'COMMAND=[^ ]*' | cut -d= -f2 | sort | uniq -c | sort -rn
echo ""

echo "⏰ АКТИВНОСТЬ В 10:XX:"
grep " 10:" "$LOG_FILE" | wc -l
echo ""

echo "🔥 САМЫЙ АКТИВНЫЙ ЧАС:"
grep "sshd" "$LOG_FILE" | awk '{print $2}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -1

