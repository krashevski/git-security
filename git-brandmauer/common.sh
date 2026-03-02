#!/usr/bin/env bash
# common.sh - mode definition script, policy core
# ✔ Всегда возвращает одно валидное значение
# ✔ Fail-safe (SAFE по умолчанию)
# ✔ Готов к расширению режимов

set -euo pipefail

SECURITY_ROOT="$HOME/.git-security"
STATE_DIR="$SECURITY_ROOT/state"
MODE_FILE="$STATE_DIR/mode"

get_git_mode() {
    local mode
    if [[ -f "$MODE_FILE" ]]; then
        mode="$(<"$MODE_FILE")"
    else
        mode="SAFE"
    fi

    case "$mode" in
        OPEN|SAFE|NORMAL)
            echo "$mode"
            ;;
        *)
            echo "SAFE"
            ;;
    esac
}

die_security() {
    echo "[SECURITY] $1" >&2
    exit 1
}
