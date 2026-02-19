#!/bin/bash
# =============================================================
# Security pre-online check
# Проверка системы перед возвратом в онлайн
# Назначение:
# - убедиться, что нет явных признаков компрометации
# - собрать данные для анализа
# - после него можно осознанно включать сеть
# =============================================================

BASE_LOG_DIR="$HOME/.local/state/security-logs"
LOG_DIR_PASSWORD="$BASE_LOG_DIR/password"
LOG_DIR_AUDIT="$BASE_LOG_DIR/audit"

mkdir -p "$LOG_DIR_PASSWORD" "$LOG_DIR_AUDIT"
chmod 700 "$BASE_LOG_DIR" "$LOG_DIR_PASSWORD" "$LOG_DIR_AUDIT"

OUT="$LOG_DIR_AUDIT/security_check_$(date +%F_%H-%M).log"

{
echo "=== DATE ==="
date

echo -e "\n=== USER / UID ==="
whoami
id

echo -e "\n=== NETWORK STATE (should be offline) ==="
ip a

echo -e "\n=== ACTIVE SOCKETS (should be empty or lo only) ==="
ss -tulpn

echo -e "\n=== LISTENING PROCESSES ==="
sudo lsof -i -P -n

echo -e "\n=== AUTH FAILURES ==="
sudo grep -i "authentication failure" /var/log/auth.log | tail -30

echo -e "\n=== SUDO FAILURES ==="
sudo grep -i "sudo" /var/log/auth.log | grep failure | tail -30

echo -e "\n=== ENABLED SERVICES ==="
systemctl list-unit-files --state=enabled

echo -e "\n=== USER AUTOSTART ==="
ls -la ~/.config/autostart 2>/dev/null

echo -e "\n=== GIT HOOKS (non-sample) ==="
find ~ -path "*/.git/hooks/*" -type f -not -name "*.sample" 2>/dev/null

echo -e "\n=== RECENT PROCESSES ==="
ps aux --sort=-start_time | head -25

} | tee "$OUT"

echo
echo "[*] Security report saved to:"
echo "    $OUT"
echo
echo "[*] Review this file BEFORE enabling networking."
echo
echo "================================================="
echo " SECURITY CHECK COMPLETED"
echo "================================================="
echo
echo "Review the report above and the log file."
echo

read -rp "Do you want to ENABLE networking now? [y/N]: " ANSWER

case "$ANSWER" in
    y|Y|yes|YES)
        echo "[*] Enabling networking..." | tee -a "$OUT"

        if command -v nmcli >/dev/null 2>&1; then
            sudo nmcli networking on
        else
            echo "[!] nmcli not found. Enable network manually." | tee -a "$OUT"
        fi

        echo "[+] Networking enabled" | tee -a "$OUT"
        ;;
    *)
        echo "[*] Networking remains DISABLED" | tee -a "$OUT"
        ;;
esac


