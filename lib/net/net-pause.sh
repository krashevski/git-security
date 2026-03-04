#!/usr/bin/env bash
# =============================================================
# net_pause.sh — временно приостановить сеть для git-security
# =============================================================

set -euo pipefail

# подключаем init и shared-lib
source "$HOME/scripts/git-security/lib/init.sh"

echo "[SECURITY] Pausing network..."
nmcli networking off

# ждём, пока сеть реально станет DOWN
net_is_down() {
    ! net_is_up
}

wait_net_up net_is_down || true

echo "[OK] Network paused"