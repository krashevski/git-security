#!/usr/bin/env bash
# passwd_offline.sh — смена пароля только при отключённой сети (Brandmauer v1.0)

set -euo pipefail

# Подключаем core/init.sh для Brandmauer
source "$HOME/.git-security/core/init.sh"

# Каталоги и файлы
NET_DIR="$SECURITY_ROOT/net"
STATE_FILE="$NET_DIR/state/panic_state"
LOG_DIR="$HOME/.local/share/brandmauer/logs"
LOG_FILE="$LOG_DIR/git-security.log"

mkdir -p "$LOG_DIR"

# Проверка состояния сети
NETWORK_STATE=$(nmcli networking)

if [[ "$NETWORK_STATE" != "disabled" ]]; then
    echo "[SECURITY] Network is ENABLED"
    echo "[DENIED] Password change allowed only OFFLINE"
    echo "[$(date '+%F %T')] DENY passwd (network enabled)" >> "$LOG_FILE"
    exit 1
fi

echo "[OK] Network is disabled"
echo "[SECURITY] Proceeding with password change..."
echo "[$(date '+%F %T')] ALLOW passwd (offline)" >> "$LOG_FILE"

# Меняем пароль для текущего пользователя
CURRENT_USER=$(whoami)

if passwd "$CURRENT_USER"; then
    echo "[INFO] Password successfully changed"
    echo "[$(date '+%F %T')] Password changed for user $CURRENT_USER, network remains disabled" >> "$LOG_FILE"
    echo "[INFO] Network is still DISABLED for security reasons."
    echo "[ACTION] If you want to restore connectivity, run:"
    echo "         $NET_DIR/emergency_net_on.sh"
    exit 0
else
    echo "[ERROR] Password change failed"
    echo "[$(date '+%F %T')] Password change FAILED for user $CURRENT_USER" >> "$LOG_FILE"
    exit 1
fi