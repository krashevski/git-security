#!/usr/bin/env bash
set -euo pipefail

PREFIX="/usr/local"
BIN_FILE="$PREFIX/bin/brandmauer"
LIB_DIR="$PREFIX/lib/brandmauer"
SHARE_DIR="$PREFIX/share/brandmauer"
STATE_DIR="$HOME/.git-security"

echo "========================================"
echo "        BRANDMAUER UNINSTALLER"
echo "========================================"

# --- удаляем CLI ---
if [[ -f "$BIN_FILE" ]]; then
    echo "[INFO] Removing CLI..."
    sudo rm -f "$BIN_FILE"
fi

# --- удаляем библиотеку ---
if [[ -d "$LIB_DIR" ]]; then
    echo "[INFO] Removing library..."
    sudo rm -rf "$LIB_DIR"
fi

# --- удаляем share ---
if [[ -d "$SHARE_DIR" ]]; then
    echo "[INFO] Removing shared data..."
    sudo rm -rf "$SHARE_DIR"
fi

echo "[OK] System files removed."

# --- спрашиваем про пользовательские данные ---
if [[ -d "$STATE_DIR" ]]; then
    echo
    read -rp "Remove user state directory ($STATE_DIR)? [y/N]: " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rm -rf "$STATE_DIR"
        echo "[INFO] User state removed."
    else
        echo "[INFO] User state preserved."
    fi
fi

echo
echo "[DONE] Brandmauer uninstalled."