#!/usr/bin/env bash
# =============================================================
# burn-zip-archives.sh — запись ZIP-архивов на CD/DVD (Brandmauer v1.0)
# =============================================================

set -euo pipefail

# Подключаем init.sh Brandmauer для определения путей
LIB_DIR="/usr/local/lib/brandmauer"
SCRIPT_DIR="$LIB_DIR/net"
source "$LIB_DIR/core/init.sh"

# Каталоги Brandmauer
NET_DIR="$LIB_DIR/net"
STATE_DIR="$HOME/.local/share/brandmauer/state"
LOG_DIR="$HOME/.local/share/brandmauer/logs"
mkdir -p "$LOG_DIR" "$STATE_DIR" "$NET_DIR"
LOG_FILE="$LOG_DIR/brandmauer.log"

log() {
    echo "[$(date '+%F %T')] $*" >> "$LOG_FILE"
}

# -------------------------------------------------------------
# Определяем целевой каталог для архивов
# -------------------------------------------------------------
TARGET_HOME="$HOME"
SOURCE_DIR="$TARGET_HOME/scripts"
[[ -d "$SOURCE_DIR" ]] || { echo "[ERROR] SOURCE_DIR not found: $SOURCE_DIR"; exit 1; }

TMP_LIST="$(mktemp)"
DEVICE="$(ls /dev/sr* 2>/dev/null | head -n1)"
[[ -n "$DEVICE" ]] || { echo "[ERROR] No optical drive found"; exit 1; }

cd "$SOURCE_DIR"

# Создаём SHA256-суммы всех ZIP
sha256sum *.zip > SHA256SUMS || { echo "[ERROR] No zip files found"; exit 1; }

# Создаём MANIFEST
echo "Brandmauer backup $(date +%F)" > MANIFEST.txt

# Список архивов для записи
find "$SOURCE_DIR" -type f -name "*.zip" > "$TMP_LIST"

if [[ ! -s "$TMP_LIST" ]]; then
    echo "[ERROR] No .zip archives found. Nothing to burn."
    rm -f "$TMP_LIST"
    exit 1
fi

# Создаём ISO
ISO_FILE="$TARGET_HOME/brandmauer-backup.iso"
mkisofs -R -J -o "$ISO_FILE" *.zip SHA256SUMS MANIFEST.txt
log "ISO created at $ISO_FILE"

echo "[OK] Archives ready to burn:"
cat "$TMP_LIST"

read -rp "Insert a blank CD/DVD and continue? (y/n): " answer
answer="${answer,,}"
answer="${answer%% *}"

if [[ "$answer" != "y" && "$answer" != "yes" ]]; then
    echo "[INFO] Operation cancelled."
    rm -f "$TMP_LIST"
    exit 0
fi

COUNT=$(wc -l < "$TMP_LIST")
echo "[INFO] Writing $COUNT archives to $DEVICE"
log "Writing $COUNT archives to $DEVICE"

# Запись ISO на диск
if wodim dev="$DEVICE" -v "$ISO_FILE"; then
    echo "[OK] Disc written successfully."
    log "Disc written successfully"
else
    echo "[ERROR] Disc write failed!"
    log "Disc write failed"
    rm -f "$TMP_LIST"
    exit 1
fi

# Проверка SHA256
CD_MOUNT="$(mktemp -d)"
sudo mount -t iso9660 "$DEVICE" "$CD_MOUNT"
sha256sum -c "$CD_MOUNT/SHA256SUMS"
sudo umount "$CD_MOUNT"
rmdir "$CD_MOUNT"

rm -f "$TMP_LIST" "$ISO_FILE" SHA256SUMS MANIFEST.txt
log "Burn and verification completed"
echo "[OK] Burn and verification completed."