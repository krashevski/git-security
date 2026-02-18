#!/usr/bin/env bash
# emergency_net_off.sh — немедленно отключить сеть

set -euo pipefail

echo "[SECURITY] Emergency network shutdown..."

nmcli networking off

# echo "[OK] Network disabled"
