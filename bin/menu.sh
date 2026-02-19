#!/usr/bin/env bash
# =============================================================
# menu.sh — GIT-SECURITY control menu
# -------------------------------------------------------------

set -euo pipefail

BIN_DIR="$(cd "$(dirname "$0")" && pwd)"

clear

while true; do
    echo "================================================="
    echo "        GIT-SECURITY CONTROL MENU"
    echo "================================================="
    echo "1) Check network status"
    echo "2) Pause network (safe mode)"
    echo "3) PANIC MODE (emergency shutdown)"
    echo "-------------------------------------------------"
    echo "0) Exit"
    echo "================================================="
    echo -n "Select option: "

    read -r choice
    echo

    case "$choice" in
        1)
            "$BIN_DIR/net_status.sh"
            ;;
        2)
            "$BIN_DIR/network-pause.sh"
            ;;
        3)
            echo "[WARNING] PANIC MODE ACTIVATION"
            read -rp "Are you sure? (yes/no): " confirm
            if [[ "$confirm" == "yes" ]]; then
                "$BIN_DIR/panic.sh"
            else
                echo "[INFO] Panic cancelled"
            fi
            ;;
        0)
            echo "Bye."
            exit 0
            ;;
        *)
            echo "[ERROR] Invalid option"
            ;;
    esac

    echo
    read -rp "Press Enter to continue..."
    clear
done
