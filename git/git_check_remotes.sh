#!/usr/bin/env bash
# =============================================================
# git_check_remotes.sh — аудит git remotes
# -------------------------------------------------------------
# Использование git_check_remotes.sh
:<<'DOC'

DOC
# =============================================================

set -euo pipefail

echo "[GIT-SECURITY] Checking git remotes..."
echo

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "[ERROR] Not a git repository"
    exit 1
}

git remote -v | while read -r name url mode; do
    printf "• %-8s %-6s %s\n" "$name" "$mode" "$url"

    if [[ "$url" =~ https:// ]]; then
        echo "  [WARN] HTTPS remote (tokens possible leak)"
    fi

    if [[ "$url" =~ git@ ]]; then
        echo "  [OK] SSH remote"
    fi
done
