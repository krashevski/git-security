#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/net_status.sh"
"$SCRIPT_DIR/passwd_offline.sh"

BIN_DIR="$HOME/scripts/git_security/bin"
STATE_DIR="$HOME/scripts/git_security/state"
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

# Функция 
wait_net_up() {
    local retries=3
    local delay=10
    local i

    for ((i=1; i<=retries; i++)); do
        echo "[INFO] Checking network status (attempt $i/$retries)..."
        if ./net_status.sh; then
            echo "[OK] Network is UP"
            return 0
        fi
        echo "[WARN] Network not ready, retrying in ${delay}s..."
        sleep "$delay"
    done

    echo "[ERROR] Network did not come up after ${retries} attempts"
    return 1
}

COUNT=$((COUNT + 1))

case "$COUNT" in
    1)
        "$BIN_DIR/emergency_net_off.sh"
        echo "[OK] Network is disabled for 10 seconds"
        sleep 10
        ./emergency_net_on.sh
        wait_net_up || true
        ;;
    2)
        "$BIN_DIR/emergency_net_off.sh"
        echo "[OK] Network is disabled for 5 minutes"
        sleep 300
        ./emergency_net_on.sh
        wait_net_up || true
        ;;
    3)
        if ./passwd_offline.sh; then
            echo "[OK] Password changed successfully"
           ./emergency_net_on.sh
           wait_net_up || true
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