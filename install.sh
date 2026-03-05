#!/usr/bin/env bash
# =============================================================
# Brandmauer 1.0 — System Installer (hooks + CLI)
# =============================================================

set -euo pipefail

# ---------------- CONFIG ----------------
PREFIX="/usr/local"
BIN_DIR="$PREFIX/bin"
LIB_DIR="$PREFIX/lib/brandmauer"
SHARE_DIR="$PREFIX/share/brandmauer"
HOOKS_DIR="$SHARE_DIR/hooks"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
COMPLETIONS_DIR="/usr/share/bash-completion/completions"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source files
BIN_SRC="$SCRIPT_DIR/bin"
LIB_SRC="$SCRIPT_DIR/lib"
HOOKS_SRC="$SCRIPT_DIR/lib/hooks"
SHAREDLIB_SRC="$SCRIPT_DIR/shared-lib"

COMPLETIONS_SRC="$SCRIPT_DIR/completions"
MODE_SRC="$LIB_SRC/git/brandmauer-mode"

# ---------------- LOGGING ----------------
info() { echo "[INFO] $*"; }
warn() { echo "[WARN] $*" >&2; }
error() { echo "[ERROR] $*" >&2; exit 1; }

# ---------------- VALIDATION ----------------
command -v git >/dev/null 2>&1 || { error "Git not found in PATH"; }

[[ -d "$BIN_SRC" ]] || error "bin directory not found: $BIN_SRC"
[[ -d "$LIB_SRC" ]] || error "lib directory not found: $LIB_SRC"
[[ -d "$HOOKS_SRC" ]] || error "hooks directory not found: $HOOKS_SRC"
[[ -d "$SHAREDLIB_SRC" ]] || error "shared-lib directory not found: $SHAREDLIB_SRC"
[[ -f "$MODE_SRC" ]] || error "brandmauer-mode not found: $MODE_SRC"

# ---------------- CREATE DIRECTORIES ----------------
info "Creating directories..."
sudo mkdir -p "$BIN_DIR" "$LIB_DIR" "$SHARE_DIR" "$HOOKS_DIR" "$SHAREDLIB_DIR" "$COMPLETIONS_DIR" 
sudo mkdir -p "$LIB_DIR/core"

# ---------------- INSTALL BINARIES ----------------
info "Installing CLI binaries..."

sudo install -m 755 "$BIN_SRC/brandmauer" "$BIN_DIR/"
sudo install -m 755 "$BIN_SRC/brandmauer-git" "$BIN_DIR/"
sudo install -m 755 "$BIN_SRC/brandmauer-net" "$BIN_DIR/"
sudo install -m 755 "$MODE_SRC" "$BIN_DIR/"

# ---------------- INSTALL LIBRARY ----------------
info "Copying library files..."
sudo cp -r "$LIB_SRC/"* "$LIB_DIR/"
sudo cp -r "$SHAREDLIB_SRC/"* "$SHAREDLIB_DIR/"

sudo mkdir -p "$LIB_DIR/core"

sudo cp -r "$LIB_SRC/core/"* "$LIB_DIR/core/"

# ---------------- INSTALL HOOKS ----------------
info "Installing git hooks..."
sudo cp -r "$HOOKS_SRC/"* "$HOOKS_DIR/"
sudo chmod +x "$HOOKS_DIR/"*

# ---------------- CONFIGURE GIT ----------------
info "Configuring global git hooksPath..."
git config --global core.hooksPath "$HOOKS_DIR"

# ---------------- INSTALL BASH COMPLETIONS ----------------
if [[ -d "$COMPLETIONS_SRC" ]]; then
    info "Installing bash completions..."
    for f in "$COMPLETIONS_SRC"/*; do
        [[ -f "$f" ]] || continue
        sudo install -m 644 "$f" "$COMPLETIONS_DIR/$(basename "$f")"
    done
fi

# ---------------- FINAL CHECK ----------------
info "Checking installation..."
command -v brandmauer >/dev/null 2>&1 || warn "brandmauer CLI not found in PATH"
[[ -d "$HOOKS_DIR" ]] || warn "Hooks directory missing: $HOOKS_DIR"
[[ -d "$SHAREDLIB_DIR" ]] || warn "Shared-lib directory missing: $SHAREDLIB_DIR"
[[ -d "$LIB_DIR" ]] || warn "Library directory missing: $LIB_DIR"

info "Brandmauer 1.0 installation complete!"
info "Run: brandmauer help"
info "Git global hooksPath: $(git config --global core.hooksPath)"