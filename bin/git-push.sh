#!/usr/bin/env bash
# =============================================================
# git-push.sh — GIT-SECURITY Brandmauer
# =============================================================

set -euo pipefail

# Подключаем init.sh — он сам определяет BASE_DIR, BIN_DIR и т.д.
source "$HOME/scripts/git-security/lib/init.sh"

# echo "[DEBUG] BASE_DIR=$BASE_DIR"
# echo "[DEBUG] BIN_DIR=$BIN_DIR"

# Теперь можно использовать переменные и функции
"$BIN_DIR/git-state.sh" push

echo "[INFO] Enabling network for git push..."

"$BIN_DIR/emergency_net_on.sh"

# --- Попытка git push с retry ---
MAX_RETRIES=3
COUNT=0

until git push "$@"; do
    COUNT=$((COUNT+1))
    echo "[WARN] git push failed (attempt $COUNT/$MAX_RETRIES)"
    if (( COUNT >= MAX_RETRIES )); then
        echo "[ERROR] git push failed after $MAX_RETRIES attempts"
        break
    fi
    echo "[INFO] Retrying in 5 seconds..."
    sleep 5
done

echo "[INFO] Running git push..."

git push "$@"

"$BIN_DIR/network-pause.sh"

# --- Отключаем сеть и очищаем состояние ---
echo "[INFO] Disabling network..."
if [[ -f "$BIN_DIR/net-pause.sh" ]]; then
    "$BIN_DIR/net-pause.sh"
else
    echo "[WARN] net-pause.sh not found, skipping network pause"
fi

"$BIN_DIR/git-state.sh" clear