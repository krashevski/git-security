#!/usr/bin/env bash
# =============================================================
# menu.sh — GIT-SECURITY control menu
# -------------------------------------------------------------

set -euo pipefail

# Подключаем init.sh — он сам определяет BASE_DIR, BIN_DIR и т.д.
source "$HOME/scripts/git-security/net-security/lib/init.sh"

clear

# Цвета
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"


while true; do
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo -e "${BOLD}${CYAN}          GIT-SECURITY CONTROL MENU                  ${RESET}"
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo " 1) Check network status"
    echo " 2) Pause network (safe mode)"
    echo " 3) PANIC MODE (emergency shutdown)"
    echo " 4) Git-security burn ZIPs"
    echo 
    echo -e " ${RED}0) Exit${RESET}"
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo -n "Select option: "

    read -r choice
    echo

    case "$choice" in
        1)
            "$SCRIPT_DIR/net-status.sh"
            ;;
        2)
            "$SCRIPT_DIR/network-pause.sh"
            ;;
        3)
            echo "[WARNING] PANIC MODE ACTIVATION"

            read -rp "Are you sure? (yes/no): " confirm

            case "${confirm,,}" in
                y|yes)
                    "$SCRIPT_DIR/panic.sh"
                    ;;
                n|no|"")
                    echo "[INFO] Panic cancelled"
                    ;;
                *)
                    echo "[WARN] Unknown answer: $confirm"
                    ;;
            esac
            ;;
        4)  "$BIN_DIR/burn-zip-archives.sh" ;; # Записать ZIP-архивы git-security на CD/DVD
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
