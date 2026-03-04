#!/usr/bin/env bash
# =============================================================
# net-status.sh — network status (Brandmauer v1.0)
# =============================================================

set -euo pipefail

# Подключаем init.sh Brandmauer для определения путей
LIB_DIR="/usr/local/lib/brandmauer"
source "$LIB_DIR/core/init.sh"

LOG_FILE="$LOG_DIR/brandmauer.log"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%F %T')] $*" >> "$LOG_FILE"
}

echo "=== Network status ==="
nmcli networking
echo

echo "=== Active connections ==="
nmcli device status
echo

log "Checked network status"
