#!/usr/bin/env bash
# =============================================================
# menu.sh — GIT-SECURITY control menu
# -------------------------------------------------------------

set -euo pipefail

# Подключаем init.sh — он сам определяет BASE_DIR, BIN_DIR и т.д.
source "$HOME/scripts/git-security/lib/init.sh"

clear

while true; do
    echo "================================================="
    echo "        GIT-SECURITY CONTROL MENU"
    echo "================================================="
    echo "1) Check network status"
    echo "2) Pause network (safe mode)"
    echo "3) PANIC MODE (emergency shutdown)"
    echo "4) Git-security burn ZIPs"
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

            case "${confirm,,}" in
                y|yes)
                    "$BIN_DIR/panic.sh"
                    ;;
                n|no|"")
                    echo "[INFO] Panic cancelled"
                    ;;
                *)
                    echo "[WARN] Unknown answer: $confirm"
                    ;;
            esac
            ;;
        4)  "$BIN_DIR/burn_zip_archives.sh" ;; # Записать ZIP-архивы git-security на CD/DVD
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
