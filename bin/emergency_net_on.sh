#!/usr/bin/env bash 
# =============================================================
# emergency_net_on.sh — включить сеть обратно
# -------------------------------------------------------------

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Подключаем библиотеку
source "$SCRIPT_DIR/../lib/net.sh"

STATUS_SCRIPT="$SCRIPT_DIR/net_status.sh"

echo "[SECURITY] Restoring network..."

nmcli networking on

wait_net_up "$STATUS_SCRIPT"

echo "[OK] Network enabled and verified"
