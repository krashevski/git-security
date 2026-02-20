#!/usr/bin/env bash
# =============================================================
# panic.sh - controls network enablement and disablement and password changes
# -------------------------------------------------------------
# Purpose:
#   Safely disable network access in an emergency and
#   change the password.
#
# Uses:
#   lib/net.sh
#   emergency_net_off.sh
#   passwd_offline.sh
# =============================================================

set -euo pipefail

# Подключаем init.sh — он сам определяет BASE_DIR, BIN_DIR и т.д.
source "$HOME/scripts/git-security/lib/init.sh"

STATE_DIR="$HOME/scripts/git-security/state"
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
        "$BIN_DIR/emergency_net_off.sh"
        echo "[OK] Network is disabled for 10 seconds"
        sleep 10
        "$BIN_DIR/emergency_net_on.sh"
        wait_net_up "$BIN_DIR/net_check.sh" || true
        ;;
    2)
        "$BIN_DIR/emergency_net_off.sh"
        echo "[OK] Network is disabled for 5 minutes"
        sleep 300
        "$BIN_DIR/emergency_net_on.sh"
        wait_net_up "$BIN_DIR/net_check.sh" || true
        ;;
    3)
        if "$BIN_DIR/passwd_offline.sh"; then
            echo "[OK] Password changed successfully"
            "$BIN_DIR/emergency_net_on.sh"
            wait_net_up "$BIN_DIR/net_check.sh" || true
        else
            echo "[ERROR] Password was NOT changed"
        fi
        ;;

    4) 
        "$BIN_DIR/emergency_net_off.sh"
        echo "[SECURITY] There is a serious network issue. Please contact support."
        COUNT=0
        ;;
    *)
        COUNT=0
        ;;
esac

echo "$TODAY|$COUNT" > "$STATE_FILE"