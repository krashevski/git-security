#!/usr/bin/env bash
# =============================================================
# emergency_net_on.sh — включить сеть обратно
# =============================================================

set -euo pipefail

# Подключаем init.sh проекта, чтобы определить SHARED_LIB, LOGS_DIR и т.д.
source "$HOME/scripts/git-security/lib/init.sh"

echo "[SECURITY] Restoring network..."

# Включаем сеть
nmcli networking on

# Ждём, пока сеть реально станет доступна
wait_net_up net_is_up

echo "[OK] Network enabled and verified"
