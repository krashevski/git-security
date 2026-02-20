#!/usr/bin/env bash
# =============================================================
# net_status.sh - network status
# -------------------------------------------------------------

set -euo pipefail

# Подключаем init.sh — он сам определяет BASE_DIR, BIN_DIR и т.д.
source "$HOME/scripts/git-security/lib/init.sh"

echo "=== Network status ==="
nmcli networking
echo

echo "=== Active connections ==="
nmcli device status

