#!/usr/bin/env bash
# core/init.sh — инициализация Brandmauer v1.0

set -euo pipefail

info()  { echo "[INFO] $*"; }
warn()  { echo "[WARN] $*"; }
error() { echo "[ERROR] $*" >&2; }

# Каталог с бинарниками CLI (brandmauer-git, brandmauer-net)
BASE_DIR="/usr/local/bin"

# Каталог библиотеки
LIB_DIR="/usr/local/lib/brandmauer"

SECURITY_ROOT="$HOME/.git-security"
STATE_DIR="$SECURITY_ROOT/state"
HOOKS_DIR="$SECURITY_ROOT/hooks"
LOG_DIR="$HOME/.local/share/brandmauer/logs"

# -------- LOGGING --------
log() {
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%F %T')] $*" >> "$LOG_DIR/init.log"
}

# -------- CREATE DIRS --------
mkdir -p "$STATE_DIR" "$HOOKS_DIR" "$LOG_DIR"

# -------- GLOBAL MODE --------
GLOBAL_MODE_FILE="$STATE_DIR/global_mode"
if [[ ! -f "$GLOBAL_MODE_FILE" ]]; then
    echo "SAFE" > "$GLOBAL_MODE_FILE"
    log "Initialized global_mode → SAFE"
fi

log "Brandmauer core initialized"

echo "[INFO] Brandmauer core initialized."
echo "[INFO] Directories created: $STATE_DIR, $HOOKS_DIR, $LOG_DIR"
echo "[INFO] Global mode file: $GLOBAL_MODE_FILE"