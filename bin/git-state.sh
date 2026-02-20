#!/usr/bin/env bash
# =============================================================
# git_state.sh — определение git-операции
# =============================================================

set -euo pipefail

STATE_DIR="$HOME/scripts/git-security/state"
STATE_FILE="$STATE_DIR/git_action"

mkdir -p "$STATE_DIR"

case "${1:-}" in
    push|pull|rebase)
        echo "$1" > "$STATE_FILE"
        echo "[STATE] git action set to: $1"
        ;;
    clear)
        rm -f "$STATE_FILE"
        echo "[STATE] git action cleared"
        ;;
    *)
        if [[ -f "$STATE_FILE" ]]; then
            cat "$STATE_FILE"
        else
            echo "none"
        fi
        ;;
esac