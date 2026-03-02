#!/usr/bin/env bash
# =============================================================
# network-pause.sh - сentral network pause controller
# -------------------------------------------------------------
# Purpose:
#   Safely disable network access for sensitive operations.
#
# Uses:
#   lib/net.sh
#   emergency_net_off.sh
#   emergency_net_on.sh
# =============================================================

set -euo pipefail

# Подключаем init.sh — он сам определяет BASE_DIR, SCRIPT_DIR и т.д.
source "$HOME/scripts/git-security/net-security/lib/init.sh"

echo "[INFO] Checking network status..."

if net_is_up; then
    echo "[SECURITY] Network is ENABLED"
    echo "[ACTION] Disabling network access..."
    "$SCRIPT_DIR/emergency_net_off.sh"
    echo "[OK] Network paused successfully"
else
    echo "[SECURITY] Network is already DISABLED"
    echo
    echo
    read -r -p "[QUESTION] Хотите включить сеть сейчас? (yes/no): " answer

    case "${answer,,}" in
        y|yes)
            echo "[INFO] Enabling network..."
            "$SCRIPT_DIR/emergency_net_on.sh"
            ;;
        n|no|"")
            echo "[INFO] Network remains disabled"
            echo "[INFO] You may re-enable network later with:"
            echo "       $SCRIPT_DIR/emergency_net_on.sh"
            ;;
        *)
            echo "[WARN] Invalid answer. Network remains disabled."
            echo "[INFO] To enable network manually run:"
            echo "       $SCRIPT_DIR/emergency_net_on.sh"
            ;;
    esac
fi
