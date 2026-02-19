#!/usr/bin/env bash
# =============================================================
# net_status.sh - network status
# -------------------------------------------------------------

set -euo pipefail

echo "=== Network status ==="
nmcli networking
echo

echo "=== Active connections ==="
nmcli device status

