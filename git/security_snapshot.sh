#!/bin/bash
###########################################################
# 4️⃣ Диагностический скрипт (только сбор информации)
# 📌 Безопасно: ничего не меняет, только выводит отчёт.
#---------------------------------------------------------
# author: v.krashevski with support ChatGPT
###########################################################


OUT="security_snapshot_$(date +%F_%H-%M).log"

{
echo "=== DATE ==="
date

echo -e "\n=== USER ==="
whoami
id

echo -e "\n=== NETWORK INTERFACES ==="
ip a

echo -e "\n=== ACTIVE CONNECTIONS ==="
ss -tulpn

echo -e "\n=== OPEN FILES (NETWORK) ==="
sudo lsof -i -P -n

echo -e "\n=== AUTH FAILURES ==="
sudo grep -i "authentication failure" /var/log/auth.log | tail -20

echo -e "\n=== SUDO FAILURES ==="
sudo grep -i "sudo" /var/log/auth.log | grep failure | tail -20

echo -e "\n=== ENABLED SERVICES ==="
systemctl list-unit-files --state=enabled

echo -e "\n=== AUTOSTART USER ==="
ls -la ~/.config/autostart 2>/dev/null

echo -e "\n=== GIT HOOKS ==="
find ~ -path "*/.git/hooks/*" -type f -not -name "*.sample" 2>/dev/null

echo -e "\n=== RECENT PROCESSES ==="
ps aux --sort=-start_time | head -20

} | tee "$OUT"

echo "Report saved to $OUT"

