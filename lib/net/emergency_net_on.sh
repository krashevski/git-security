#!/usr/bin/env bash
# =============================================================
# emergency_net_on.sh — включить сеть обратно (Brandmauer v1.0)
# =============================================================

set -euo pipefail

# Подключаем core/init.sh Brandmauer
LIB_DIR="/usr/local/lib/brandmauer"
source "$LIB_DIR/core/init.sh"
source "$LIB_DIR/net/net.sh"

# Каталоги для net
NET_DIR="$LIB_DIR/net"
STATE_DIR="$NET_DIR/state"
LOG_DIR="$HOME/.local/share/brandmauer/logs"
LOG_FILE="$LOG_DIR/git-security.log"

mkdir -p "$LOG_DIR"

echo "[SECURITY] Restoring network..."
echo "[$(date '+%F %T')] Network restore initiated" >> "$LOG_FILE"

# Включаем сеть
nmcli networking on

# Ждём, пока сеть реально станет доступна
if ! wait_net_up net_is_up; then
    echo "[WARN] Network may not be fully up yet"
    echo "[$(date '+%F %T')] Warning: network may not be fully up" >> "$LOG_FILE"
else
    echo "[OK] Network enabled and verified"
    echo "[$(date '+%F %T')] Network successfully restored" >> "$LOG_FILE"
fi