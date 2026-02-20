#!/usr/bin/env bash
# =============================================================
# burn_zip_archives.sh — запись ZIP-архивов на CD/DVD
# Проект: git-security
# -------------------------------------------------------------
:<<'DOC'
# Использование: 
chmod +x burn_zip_archives.sh
./burn_zip_archives.sh
DOC
# =============================================================

set -euo pipefail

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"
SOURCE_DIR="$REAL_HOME/scripts"

[[ -d "$SOURCE_DIR" ]] || {
    echo "[ERROR] SOURCE_DIR not found: $SOURCE_DIR"
    exit 1
}

TMP_LIST="/tmp/zip_to_burn.lst"
DEVICE="$(ls /dev/sr* 2>/dev/null | head -n1)"
[[ -z "$DEVICE" ]] && { echo "[ERROR] No optical drive found"; exit 1; }

cd "$SOURCE_DIR"

# Создаём SHA256-суммы всех ZIP
sha256sum *.zip > SHA256SUMS

# Создаём MANIFEST
echo "git-security backup $(date +%F)" > MANIFEST.txt

echo "[INFO] Searching for .zip archives in $SOURCE_DIR ..."

find "$SOURCE_DIR" -type f -name "*.zip" > "$TMP_LIST"

if [[ ! -s "$TMP_LIST" ]]; then
    echo "[ERROR] No .zip archives found. Nothing to burn."
    rm -f "$TMP_LIST"
    exit 1
fi

mkisofs -R -J \
  -o /home/vladislav/scripts-backup.iso \
  /home/vladislav/scripts/*.zip \
  /home/vladislav/scripts/SHA256SUMS \
  /home/vladislav/scripts/MANIFEST.txt

ISO_MOUNT="/tmp/iso_mnt"
mkdir -p "$ISO_MOUNT"
sudo mount -o loop,ro /home/vladislav/scripts-backup.iso "$ISO_MOUNT"
ls "$ISO_MOUNT"
sudo umount "$ISO_MOUNT"
rmdir "$ISO_MOUNT"

echo "[OK] Archives to be written:"
cat "$TMP_LIST"

echo
read -rp "Insert a blank CD/DVD and continue? (y/n): " answer
answer="${answer,,}"     # в нижний регистр
answer="${answer%% *}"   # убрать всё после пробела

if [[ "$answer" != "y" && "$answer" != "yes" ]]; then
    echo "[INFO] Operation cancelled."
    rm -f "$TMP_LIST"
    exit 0
fi

COUNT=$(wc -l < "$TMP_LIST")
echo "[INFO] Writing $COUNT archives to $DEVICE"

# Запись ISO на диск
if wodim dev="$DEVICE" -v /home/vladislav/scripts-backup.iso; then
    echo "[OK] Disc written successfully."
else
    echo "[ERROR] Disc write failed!"
    rm -f "$TMP_LIST"
    exit 1
fi

# Монтирование и проверка SHA256
CD_MOUNT="/tmp/cd_mnt"
sudo mkdir -p "$CD_MOUNT"
sudo mount -t iso9660 "$DEVICE" "$CD_MOUNT"
sha256sum -c "$CD_MOUNT/SHA256SUMS"
ls "$CD_MOUNT"
sudo umount "$CD_MOUNT"
rmdir "$CD_MOUNT"

rm -f "$TMP_LIST"
rm -f /home/vladislav/scripts-backup.iso
rm -f SHA256SUMS MANIFEST.txt
