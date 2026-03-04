#!/usr/bin/env bash
# common.sh — git-brandmauer policy core
# ✔ Per-repo mode
# ✔ Fail-safe (SAFE default)
# ✔ No recursion
# ✔ Minimal git calls

set -euo pipefail

# ========= CONFIG =========
SECURITY_ROOT="$HOME/.git-security"
STATE_DIR="$SECURITY_ROOT/state"
mkdir -p "$STATE_DIR"

# ВАЖНО: вызываем реальный git, чтобы избежать рекурсии wrapper
REAL_GIT="${REAL_GIT:-$(command -v git || true)}"
[[ -x "$REAL_GIT" ]] || { echo "[ERROR] git not found"; exit 1; }

# ========= INTERNAL: determine current repo name =========
get_current_repo_name() {

    # Если git недоступен — fail-safe
    [[ -x "$REAL_GIT" ]] || {
        echo ""
        return
    }

    # Не внутри репозитория → нет режима
    if ! "$REAL_GIT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo ""
        return
    fi

    local top
    top="$("$REAL_GIT" rev-parse --show-toplevel 2>/dev/null || echo "")"

    [[ -n "$top" ]] || {
        echo ""
        return
    }

    basename "$top"
}

# ========= PUBLIC: get mode =========
get_git_mode() {

    local repo_name
    repo_name="$(get_current_repo_name)"

    # Если не в репозитории → SAFE
    [[ -n "$repo_name" ]] || {
        echo "SAFE"
        return
    }

    local repo_mode_file="$STATE_DIR/${repo_name}.mode"

    if [[ -f "$repo_mode_file" ]]; then
        local mode
        mode="$(<"$repo_mode_file")"

        case "$mode" in
            OPEN|SAFE|NORMAL)
                echo "$mode"
                ;;
            *)
                echo "SAFE"
                ;;
        esac
    else
        echo "SAFE"
    fi
}

# ========= POLICY ENGINE =========
enforce_git_policy() {
    local cmd="${1:-}"  # <- безопасно, если аргумент не задан
    local mode
    mode="$(get_git_mode)"

    case "$mode" in
        SAFE)
            case "$cmd" in
                pull|push|fetch|merge|rebase|reset|commit|tag)
                    die_security "git $cmd is DISABLED in SAFE mode"
                    ;;
            esac
            ;;
        NORMAL)
            case "$cmd" in
                pull|push|fetch|merge)
                    die_security "git $cmd is DISABLED in NORMAL mode"
                    ;;
            esac
            ;;
        OPEN)
            # Всё разрешено
            ;;
    esac
}

# ========= ERROR =========
die_security() {
    local repo
    repo="$(get_current_repo_name)"
    echo "[SECURITY][$repo] $1" >&2
    exit 1
}