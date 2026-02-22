#!/usr/bin/env bash
# common.sh

set -euo pipefail

# SECURITY_ROOT="$HOME/scripts/git-security/git"
SECURITY_ROOT="$HOME/.git-security"
STATE_DIR="$SECURITY_ROOT/state"
MODE_FILE="$STATE_DIR/mode"

get_git_mode() {
    [[ -f "$MODE_FILE" ]] || echo "OPEN"
    cat "$MODE_FILE" 2>/dev/null || echo "OPEN"
}

die_security() {
    echo "[SECURITY] $1" >&2
    exit 1
}
