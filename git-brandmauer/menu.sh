#!/usr/bin/env bash
# git-brandmauer interactive menu — colored version

set -euo pipefail

STATE_DIR="$HOME/.git-security/state"

# Список репозиториев (можно редактировать)
REPOS=("git-guides" "git-security" "media-panel-template" "REBK" "shared-lib")
MODES=("OPEN" "SAFE" "ONLY_PUSH")

# Цвета
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

show_menu() {
    # Читаем глобальный режим
    GLOBAL_MODE="UNKNOWN"
    GLOBAL_FILE="$STATE_DIR/mode"
    if [[ -f "$GLOBAL_FILE" ]]; then
        GLOBAL_MODE=$(<"$GLOBAL_FILE")
    fi
    
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo -e "${BOLD}${CYAN}                GIT-BRANDMAUER MENU                 ${RESET}"
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo -e "${BOLD}Select repository to manage:${RESET}"

    for i in "${!REPOS[@]}"; do
        repo="${REPOS[$i]}"
        mode_file="$STATE_DIR/${repo}.mode"
        if [[ -f "$mode_file" ]]; then
            current_mode=$(<"$mode_file")
        else
            current_mode="$GLOBAL_MODE"
        fi
        # Цветной вывод репозитория и режима
        echo -e "  ${GREEN}$((i+1))) $repo${RESET} (mode: ${YELLOW}$current_mode${RESET})"
    done
    echo
    echo -e "  ${RED}0) Exit${RESET}"
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
}

select_repo() {
    read -rp "$(echo -e ${BOLD}${CYAN}Enter number: ${RESET})" choice
    if [[ "$choice" == "0" ]]; then
        echo -e "${MAGENTA}Exiting...${RESET}"
        exit 0
    fi
    if (( choice < 1 || choice > ${#REPOS[@]} )); then
        echo -e "${RED}[ERROR] Invalid choice${RESET}"
        return 1
    fi
    REPO="${REPOS[$((choice-1))]}"
    echo -e "${BLUE}Selected repository:${RESET} ${GREEN}$REPO${RESET}"
}

select_mode() {
    echo -e "${BOLD}Select mode for ${GREEN}$REPO${RESET}:"
    for i in "${!MODES[@]}"; do
        echo -e "  ${YELLOW}$((i+1))) ${MODES[$i]}${RESET}"
    done
    read -rp "$(echo -e ${BOLD}${CYAN}Enter number: ${RESET})" choice
    if (( choice < 1 || choice > ${#MODES[@]} )); then
        echo -e "${RED}[ERROR] Invalid choice${RESET}"
        return 1
    fi
    MODE="${MODES[$((choice-1))]}"
    echo -e "${BLUE}Selected mode:${RESET} ${YELLOW}$MODE${RESET}"
}

# ========== MAIN LOOP ==========
while true; do
    show_menu
    select_repo || continue
    select_mode || continue

    git-brandmauer-mode "$REPO" "$MODE"
    echo -e "${BLUE}[INFO]${RESET} $REPO set to $MODE"
    echo
done