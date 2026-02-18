#!/usr/bin/env bash
# passwd_offline.sh — смена пароля только при отключённой сети

set -euo pipefail

BASE="$HOME/scripts/git-security"
BIN_DIR="$HOME/scripts/git-security/bin"
STATE_DIR="$HOME/scripts/git-security/state"
STATE_FILE="$STATE_DIR/panic_state"
LOG_DIR="$BASE/logs"
LOG_FILE="$LOG_DIR/git-security.log"

mkdir -p "$BASE/logs"

NETWORK_STATE=$(nmcli networking)

if [[ "$NETWORK_STATE" != "disabled" ]]; then
    echo "[SECURITY] Network is ENABLED"
    echo "[DENIED] Password change allowed only OFFLINE"
    echo "$(date '+%F %T') DENY passwd (network enabled)" >> "$LOG_FILE"
    exit 1
fi

echo "[OK] Network is disabled"
echo "[SECURITY] Proceeding with password change..."
echo "$(date '+%F %T') ALLOW passwd (offline)" >> "$LOG_FILE"

if passwd username; then
    exit 0
else
    exit 1
fi

echo
echo "[INFO] Password successfully changed"
echo "$(date '+%F %T') Password changed, network remains disabled" >> "$LOG_FILE"
echo "[INFO] Network is still DISABLED for security reasons."
echo "[ACTION] If you want to restore connectivity, run:"
echo "         $BIN_DIR/emergency_net_on.sh"
