# =============================================================
# /lib/net.sh - Функция проверки состояния сетевого подключения
# -------------------------------------------------------------
# Использование net.sh
:<<'DOC'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BIN_DIR/../lib/net.sh"
wait_net_up "$BIN_DIR/net_status.sh" || true
DOC
# =============================================================

wait_net_up() {
    local status_script="${1:?net_status.sh path required}"
    local retries=5
    local delay=10

    for ((i=1; i<=retries; i++)); do
        echo "[INFO] Checking network status (attempt $i/$retries)..."
        if "$status_script"; then
            echo "[OK] Network is UP"
            return 0
        fi
        echo "[WARN] Network not ready, retrying in ${delay}s..."
        sleep "$delay"
    done

    echo "[ERROR] Network did not come up after ${retries} attempts"
    return 1
}


# -------------------------------------------------------------
# net_is_up() - проверяет текущее состояние сети
# возвращает 0, если сеть UP, 1 если DOWN
# -------------------------------------------------------------
net_is_up() {
    if nmcli networking | grep -q enabled; then
        return 0
    else
        return 1
    fi
}