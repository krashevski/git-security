#!/usr/bin/env bash
# git-brandmauer uninstall script

set -euo pipefail

SECURITY_ROOT="$HOME/.git-security"
LOCAL_BIN="$HOME/.local/bin"
WRAPPER="$LOCAL_BIN/git"

echo "[INFO] Removing git-brandmauer core..."

# 1. Убираем hooksPath
git config --global --unset core.hooksPath || true

# 2. Удаляем core
rm -rf "$SECURITY_ROOT"

# 3. Проверяем wrapper
if [[ -f "$WRAPPER" ]]; then
    echo "[WARN] git UX wrapper still exists: $WRAPPER"
    echo "[WARN] Remove it manually if no longer needed:"
    echo "[WARN]   rm -f $WRAPPER"
else
    echo "[INFO] No git wrapper found in $LOCAL_BIN"
fi

echo "[OK] git-brandmauer core removed"