#!/usr/bin/env bash
# =============================================================
# network-pause.sh — central network pause controller
# Brandmauer v1.0
# =============================================================

set -euo pipefail

# Подключаем init.sh Brandmauer
LIB_DIR="/usr/local/lib/brandmauer"
SCRIPT_DIR="$LIB_DIR/net"
source "$LIB_DIR/core/init.sh"
source "$LIB_DIR/net/net.sh"

LOG_DIR="$HOME/.local/share/brandmauer/logs"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%F %T')] $*" >> "$LOG_DIR/network.log"
}

echo "[INFO] Checking network status..."

if net_is_up; then
    echo "[SECURITY] Network is ENABLED"
    echo "[ACTION] Disabling network access..."
    "$SCRIPT_DIR/emergency_net_off.sh"
    echo "[OK] Network paused successfully"
    log "Network paused"
else
    echo "[SECURITY] Network is already DISABLED"
    read -rp "[QUESTION] Do you want to turn on the network now? [y/N]: " answer
    answer="${answer,,}"  # в нижний регистр

    case "$answer" in
        y|yes)
            echo "[INFO] Enabling network..."
            "$SCRIPT_DIR/emergency_net_on.sh"
            wait_net_up "$SCRIPT_DIR/net_check.sh" || true
            log "Network re-enabled by user"
            ;;
        n|no|"")
            echo "[INFO] Network remains disabled"
            echo "[INFO] To re-enable later run:"
            echo "       $SCRIPT_DIR/emergency_net_on.sh"
            log "Network remains disabled"
            ;;
        *)
            echo "[WARN] Invalid answer. Network remains disabled."
            echo "[INFO] To enable manually run:"
            echo "       $SCRIPT_DIR/emergency_net_on.sh"
            log "Invalid input, network left disabled"
            ;;
    esac
fi