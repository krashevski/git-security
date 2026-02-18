#!/usr/bin/env bash
# =============================================================
# git_push_guard.sh — защита git push (HOME-only)
# -------------------------------------------------------------
# Использование git_push_guard.sh
:<<'DOC'

DOC
# =============================================================
set -euo pipefail

BASE="$HOME/scripts/git_security"
FLAG="$BASE/state/push_unlocked.flag"
LOG="$BASE/logs/git_security.log"

NETWORK_STATE=$(nmcli networking)

if [[ "$NETWORK_STATE" == "enabled" && ! -f "$FLAG" ]]; then
    echo "[SECURITY] Network is ENABLED"
    echo "[DENIED] git push blocked"
    echo "Hint: run git_push_unlock.sh"
    echo "$(date '+%F %T') DENY push (network enabled)" >> "$LOG"
    exit 1
fi

rm -f "$FLAG" 2>/dev/null || true
echo "$(date '+%F %T') ALLOW push" >> "$LOG"

exec git push "$@"
