#!/usr/bin/env bash
# =============================================================
# git-rebase.sh — GIT-SECURITY Brandmauer
# =============================================================

set -euo pipefail

# Подключаем init.sh — он сам определяет BASE_DIR, BIN_DIR и т.д.
source "$HOME/scripts/git-security/lib/init.sh"

# echo "[DEBUG] BASE_DIR=$BASE_DIR"
# echo "[DEBUG] BIN_DIR=$BIN_DIR"

# Теперь можно использовать переменные и функции
"$BIN_DIR/git-state.sh" rebase

echo "[INFO] Enabling network for git rebase..."

"$BIN_DIR/emergency_net_on.sh"

# --- Попытка git rebase с retry ---
MAX_RETRIES=3
COUNT=0

until git rebase "$@"; do
    COUNT=$((COUNT+1))
    echo "[WARN] git rebase failed (attempt $COUNT/$MAX_RETRIES)"
    if (( COUNT >= MAX_RETRIES )); then
        echo "[ERROR] git rebase failed after $MAX_RETRIES attempts"
        break
    fi
    echo "[INFO] Retrying in 5 seconds..."
    sleep 5
done

echo "[INFO] Running git rebase..."

git rebase "$@"

# "$BIN_DIR/net-pause.sh"

# --- Отключаем сеть и очищаем состояние ---
echo "[INFO] Disabling network..."
if [[ -f "$BIN_DIR/net-pause.sh" ]]; then
    "$BIN_DIR/net-pause.sh"
else
    echo "[WARN] net-pause.sh not found, skipping network pause"
fi

echo "[INFO] Disabling network..."

"$BIN_DIR/git-state.sh" clear