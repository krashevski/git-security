#!/usr/bin/env bash
# =============================================================
# git_push_unlock.sh — разрешить git push (HOME-only)
# -------------------------------------------------------------
# Использование git_push_guard.sh
:<<'DOC'

DOC
# =============================================================
set -euo pipefail

set -euo pipefail

BASE="$HOME/scripts/git_security"
FLAG="$BASE/state/push_unlocked.flag"
LOG="$BASE/logs/git_security.log"

mkdir -p "$BASE/state" "$BASE/logs"

echo "$(date '+%F %T') UNLOCK git push" >> "$LOG"
touch "$FLAG"

echo "[SECURITY] git push UNLOCKED"
