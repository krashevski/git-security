#!/usr/bin/env bash
# panic.sh — Brandmauer v1.0 network emergency + password

set -euo pipefail

# Подключаем core/init.sh
LIB_DIR="/usr/local/lib/brandmauer"
source "$LIB_DIR/core/init.sh"
source "$LIB_DIR/net/net.sh"

# Каталог net-security внутри Brandmauer
SCRIPT_DIR="$LIB_DIR/net"
STATE_DIR="$HOME/.local/share/brandmauer/state"
STATE_FILE="$STATE_DIR/panic_state"

mkdir -p "$STATE_DIR"

TODAY="$(date +%F)"
COUNT=0
SAVED_DATE=""

if [[ -f "$STATE_FILE" ]]; then
    IFS='|' read -r SAVED_DATE COUNT < "$STATE_FILE"
fi

# Новый день — сброс счётчика
if [[ "$SAVED_DATE" != "$TODAY" ]]; then
    COUNT=0
fi

COUNT=$((COUNT + 1))

case "$COUNT" in
    1)
        "$SCRIPT_DIR/emergency_net_off.sh"
        echo "[OK] Network is disabled for 10 seconds"
        sleep 10
        "$SCRIPT_DIR/emergency_net_on.sh"
        wait_net_up "$SCRIPT_DIR/net_check.sh" || true
        ;;
    2)
        "$SCRIPT_DIR/emergency_net_off.sh"
        echo "[OK] Network is disabled for 5 minutes"
        sleep 300
        "$SCRIPT_DIR/emergency_net_on.sh"
        wait_net_up "$SCRIPT_DIR/net_check.sh" || true
        ;;
    3)
        if "$SCRIPT_DIR/passwd_offline.sh"; then
            echo "[OK] Password changed successfully"
            "$SCRIPT_DIR/emergency_net_on.sh"
            wait_net_up "$SCRIPT_DIR/net_check.sh" || true
        else
            echo "[ERROR] Password was NOT changed"
        fi
        ;;
    4)
        "$SCRIPT_DIR/emergency_net_off.sh"
        echo "[SECURITY] There is a serious network issue. Please contact support."
        COUNT=0
        ;;
    *)
        COUNT=0
        ;;
esac

echo "$TODAY|$COUNT" > "$STATE_FILE"