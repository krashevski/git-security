#!/usr/bin/env bash
# =============================================================
# network-pause.sh - Central network pause controller
# -------------------------------------------------------------
# Purpose:
#   Safely disable network access for sensitive operations
#   (password change, git operations, emergency mode).
#
# Uses:
#   lib/net.sh
#   emergency_net_off.sh
#   emergency_net_on.sh
# =============================================================

set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BIN_DIR="$BASE_DIR/bin"
LIB_DIR="$BASE_DIR/lib"

source "$LIB_DIR/net.sh"

echo "[INFO] Checking network status..."

if net_is_up; then
    echo "[SECURITY] Network is ENABLED"
    echo "[ACTION] Disabling network access..."
    "$BIN_DIR/emergency_net_off.sh"
    echo "[OK] Network paused successfully"
else
    echo "[SECURITY] Network is already DISABLED"
    echo
    echo "[INFO] You may re-enable network access with:"
    echo "       $BIN_DIR/emergency_net_on.sh"
fi
