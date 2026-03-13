#!/usr/bin/env bash
set -euo pipefail

# ---------------- CONFIG ----------------
PREFIX="/usr/local"
SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/logging.sh"

STATE_DIR="$HOME/.git-security/state"
REPO_LIST_FILE="$HOME/.git-security/repos.list"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$PREFIX/lib/brandmauer"
GIT_DIR="$LIB_DIR/git"
NET_DIR="$LIB_DIR/net"
UI_DIR="$LIB_DIR/ui"

MODES=("SAFE" "NORMAL" "OPEN")

# Цвета
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

# ---------------- INIT ----------------
init_repo_list() { [[ -f "$REPO_LIST_FILE" ]] || touch "$REPO_LIST_FILE"; }
load_repos() { mapfile -t REPOS < "$REPO_LIST_FILE"; }
git_brandmauer_set_mode() {
    local repo="$1"
    local mode="$2"
    mkdir -p "$STATE_DIR"
    repo_name=$(basename "$repo")
    echo "$mode" > "$STATE_DIR/${repo_name}.mode"
}

mode_color() {
    case "$1" in
        SAFE) echo -e "$RED" ;;
        NORMAL) echo -e "$YELLOW" ;;
        OPEN) echo -e "$GREEN" ;;
        *) echo -e "$CYAN" ;;
    esac
}

init_repo_list
load_repos

# ---------------- MENU FUNCTIONS ----------------
show_menu() {
    clear
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo -e "               ${BOLD}${CYAN}GIT-BRANDMAUER MENU${RESET}"
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo -e " ${BOLD}Select repository to manage:${RESET}"

    for i in "${!REPOS[@]}"; do
        repo="${REPOS[$i]}"
        repo_name=$(basename "$repo")
        mode_file="$STATE_DIR/${repo_name}.mode"
        [[ -f "$mode_file" ]] && current_mode=$(<"$mode_file") || current_mode="SAFE"
        color_mode=$(mode_color "$current_mode")
        echo -e "   $((i+1))) $repo_name (mode: ${color_mode}$current_mode${RESET})"
    done

    repo_count=${#REPOS[@]}
    manage_index=$((repo_count+1))
    repos_index=$((repo_count+2))
    settings_index=$((repo_count+3))
    network_index=$((repo_count+4))
    burn_zip_index=$((repo_count+5))

    echo -e " ${BOLD}Brandmauer settings: ${RESET}"
    echo -e "   $manage_index) Manage repositories"
    echo -e "   $repos_index) Close active repositories"
    echo -e "   $settings_index) Settings automatic SAFE for commit, checkout, merge"
    echo -e " ${BOLD}Net-security: ${RESET}"
    echo -e "   $network_index) Control network"
    echo -e "   $burn_zip_index) Burn zip archives"
    echo
    echo -e " ${RED}0) Exit ${RESET}"
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
}

manage_repositories() {
    while true; do
        echo
        echo -e "${BOLD}${CYAN}====================================================${RESET}"
        echo -e "              ${BOLD}${CYAN}Repository manager ${RESET}"
        echo -e "${BOLD}${CYAN}====================================================${RESET}"
        echo " 1) Add repository"
        echo " 2) Remove repository"
        echo " 3) List repositories"
        echo
        echo " 4) Back"
        echo -e "${BOLD}${CYAN}====================================================${RESET}"
        read -rp "Select: " choice

        case "$choice" in
            1)
                read -rp "Enter repository name: " repo_input
                # Попытка абсолютного пути
                repo=$(realpath "$repo_input" 2>/dev/null || true)
                # Если не существует, пробуем из стандартной папки скриптов
                [[ -d "$repo/.git" ]] || repo="$HOME/scripts/$repo_input"

                if [[ ! -d "$repo/.git" ]]; then
                    echo "Not a git repository."
                    continue
                fi

                if grep -qx "$repo" "$REPO_LIST_FILE" 2>/dev/null; then
                    echo "Already exists."
                else
                    echo "$repo" >> "$REPO_LIST_FILE"
                    mkdir -p "$STATE_DIR"
                    repo_name=$(basename "$repo")
                    [[ ! -f "$STATE_DIR/$repo_name.mode" ]] && echo "SAFE" > "$STATE_DIR/$repo_name.mode"
                    info "Initialized mode for repository '$repo_name' → SAFE"
                    echo "Added."
                    load_repos
                fi
                ;;
            2)
                read -rp "Enter repository path to remove: " repo_input
                repo=$(realpath "$repo_input" 2>/dev/null || true)
                [[ -d "$repo/.git" ]] || repo="$HOME/scripts/$repo_input"

                grep -vx "$repo" "$REPO_LIST_FILE" > "$REPO_LIST_FILE.tmp"
                mv "$REPO_LIST_FILE.tmp" "$REPO_LIST_FILE"
                repo_name=$(basename "$repo")
                rm -f "$STATE_DIR/$repo_name.mode"
                echo "Removed."
                load_repos
                ;;
            3)
                echo
                echo -e "${BOLD}${CYAN}====================================================${RESET}"
                echo -e "             ${BOLD}${CYAN}List repositories                      ${RESET}"
                echo -e "${BOLD}${CYAN}====================================================${RESET}"
                cat "$REPO_LIST_FILE"
                ;;
            4)
                break
                ;;
            *)
                echo "Invalid choice"
                ;;
        esac
    done
}

select_mode() {
    repo_name=$(basename "$REPO")
    mode_file="$STATE_DIR/$repo_name.mode"
    [[ -f "$mode_file" ]] && MODE=$(<"$mode_file") || MODE="SAFE"

    echo -e "${BOLD}Current mode for ${CYAN}$REPO${RESET}: $(mode_color "$MODE")$MODE${RESET}"
    echo -e "${BOLD}Select new mode:${RESET}"
    for i in "${!MODES[@]}"; do
        color_mode=$(mode_color "${MODES[$i]}")
        echo -e "  $((i+1))) ${color_mode}${MODES[$i]}${RESET}"
    done

    read -rp "Enter number: " choice
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#MODES[@]} )); then
        echo -e "${RED}[ERROR] Invalid choice${RESET}"
        return 1
    fi

    MODE="${MODES[$((choice-1))]}"
    git_brandmauer_set_mode "$REPO" "$MODE"
    info " $REPO set to $(mode_color "$MODE")$MODE"
}

select_repo() {
    read -rp "Enter number: " choice
    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}[ERROR] Invalid choice${RESET}"
        return 1
    fi

    repo_count=${#REPOS[@]}
    manage_index=$((repo_count+1))
    repos_index=$((repo_count+2))
    settings_index=$((repo_count+3))
    network_index=$((repo_count+4))
    burn_zip_index=$((repo_count+5))

    # Exit
    [[ "$choice" == "0" ]] && { echo "Exiting..."; exit 0; }

    # Manage repositories
    (( choice == manage_index )) && { manage_repositories; load_repos; return 1; }

    # Close active repositories
    (( choice == repos_index )) && {
        if [[ -x "$GIT_DIR/close_active_repos.sh" ]]; then
            "$GIT_DIR/close_active_repos.sh"
        else
            error "close_active_repos.sh not found"
        fi
        return 1
    }

    # Automatic SAFE
    (( choice == settings_index )) && { "$UI_DIR/settings_menu.sh"; return 1; }

    # Network
    (( choice == network_index )) && { "$UI_DIR/net-menu.sh"; return 1; }

    # Burn zip
    (( choice == burn_zip_index )) && {
        if [[ ! -e /dev/sr0 && ! -e /dev/cdrom && ! -e /dev/dvd ]]; then
            warn "No CD/DVD drive detected."
            return 1
        fi
        [[ -x "$GIT_DIR/burn-zip-archives.sh" ]] && "$GIT_DIR/burn-zip-archives.sh" || echo -e "${RED}[ERROR] burn-zip-archives.sh not found${RESET}"
        return 1
    }

    # Validate repo selection
    (( choice < 1 || choice > repo_count )) && { echo -e "${RED}[ERROR] Invalid choice${RESET}"; return 1; }

    REPO="${REPOS[$((choice-1))]}"
    echo -e "Selected repository: ${CYAN}$REPO${RESET}"
}

# ---------------- MAIN LOOP ----------------
while true; do
    show_menu
    select_repo || continue
    select_mode || continue
    echo
done