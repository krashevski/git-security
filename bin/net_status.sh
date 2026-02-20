#!/usr/bin/env bash
# =============================================================
# net_status.sh - network status
# -------------------------------------------------------------

set -euo pipefail

source "$HOME/scripts/shared-lib/net.sh"

echo "=== Network status ==="
nmcli networking
echo

echo "=== Active connections ==="
nmcli device status

