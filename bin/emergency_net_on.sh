#!/usr/bin/env bash
# emergency_net_on.sh — включить сеть обратно

set -euo pipefail

echo "[SECURITY] Restoring network..."

nmcli networking on

echo "[OK] Network enabled"
