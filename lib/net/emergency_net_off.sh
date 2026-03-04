#!/usr/bin/env bash
# emergency_net_off.sh — немедленно отключить сеть

set -euo pipefail

# Подключаем core/init.sh Brandmauer
LIB_DIR="/usr/local/lib/brandmauer"
source "$LIB_DIR/core/init.sh"

echo "[SECURITY] Emergency network shutdown..."
nmcli networking off

log "[ACTION] Network disabled (emergency)"