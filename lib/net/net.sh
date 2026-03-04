# =============================================================
# shared-lib/net.sh - Функция проверки состояния сетевого подключения
# -------------------------------------------------------------
# Использование net.sh
:<<'DOC'
# Использование
wait_net_up net_is_up
DOC
# =============================================================

wait_net_up() {
    local check_func="${1:-}"  # допускаем пустое значение
    [[ -z "$check_func" ]] && { echo "[ERROR] check function required"; return 1; }

    local retries=5
    local delay=10

    for ((i=1; i<=retries; i++)); do
        echo "[INFO] Checking network status (attempt $i/$retries)..."
        # вызываем функцию через команду `"$check_func"` в подпроцессе
        "$check_func"
        if [[ $? -eq 0 ]]; then
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