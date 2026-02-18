# =============================================================
# /lib/net.sh - Функция проверки состояния сетевого подключения
# -------------------------------------------------------------
# Использование net.sh
:<<'DOC'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/net.sh"

./emergency_net_on.sh
wait_net_up "$SCRIPT_DIR/net_status.sh" || true
DOC
# =============================================================

wait_net_up() {
    local retries=3
    local delay=10
    local i

    for ((i=1; i<=retries; i++)); do
        echo "[INFO] Checking network status (attempt $i/$retries)..."
        if ./net_status.sh; then
            echo "[OK] Network is UP"
            return 0
        fi
        echo "[WARN] Network not ready, retrying in ${delay}s..."
        sleep "$delay"
    done

    echo "[ERROR] Network did not come up after ${retries} attempts"
    return 1
}