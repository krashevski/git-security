#!/usr/bin/env bash
# git-brandmauer install script

set -euo pipefail

# ========= CONFIG =========
SECURITY_ROOT="$HOME/.git-security"
HOOKS_DIR="$SECURITY_ROOT/hooks"
STATE_DIR="$SECURITY_ROOT/state"
MODE_FILE="$STATE_DIR/mode"

LOCAL_BIN="$HOME/.local/bin"
WRAPPER_SRC="$(cd "$(dirname "$0")" && pwd)/bin/git"
WRAPPER_DST="$LOCAL_BIN/git"

# ========= INSTALL git-brandmauer-mode =========
MODE_SCRIPT_SRC="$(cd "$(dirname "$0")" && pwd)/git-brandmauer-mode"
MODE_SCRIPT_DST="$LOCAL_BIN/git-brandmauer-mode"

INSTALL_MODE=false
ADD_PATH=false

DRY_RUN=false
INSTALL_WRAPPER=false
FORCE_WRAPPER=false

# ========= UTILS =========
log()  { echo "[INFO] $*"; }
warn() { echo "[WARN] $*" >&2; }
die()  { echo "[ERROR] $*" >&2; exit 1; }

run() {
    if $DRY_RUN; then
        echo "[DRY-RUN] $*"
    else
        "$@"
    fi
}

# ========= ARG PARSING =========
for arg in "$@"; do
    case "$arg" in
        --with-wrapper)   INSTALL_WRAPPER=true ;;
        --with-mode)      INSTALL_MODE=true ;;
        --force-wrapper)  FORCE_WRAPPER=true ;;
        --add-path)       ADD_PATH=true ;;
        --dry-run)        DRY_RUN=true ;;
        --help)
            cat <<EOF
git-brandmauer install script

Usage:
  ./install.sh [options]

Options:
  --with-wrapper    Install git UX wrapper (~/.local/bin/git)
  --with-mode       Install 
  --force-wrapper   Overwrite existing git wrapper
  --add-path        $PATH — пользовательская политика
  --dry-run         Show actions without applying
  --help            Show this help
EOF
            exit 0
            ;;
        *)
            die "Unknown option: $arg"
            ;;
    esac
done

# Функция добавления пути
add_path() {
    local line='export PATH="$HOME/.local/bin:$PATH"'

    for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        [[ -f "$rc" ]] || continue

        if grep -q "$line" "$rc"; then
            log "PATH already configured in $(basename "$rc")"
        else
            log "Adding ~/.local/bin to PATH in $(basename "$rc")"
            run sh -c "echo '' >> '$rc'"
            run sh -c "echo '# git-brandmauer' >> '$rc'"
            run sh -c "echo '$line' >> '$rc'"
        fi
    done
}

# ========= INSTALL CORE =========
log "Installing git-brandmauer core..."

run mkdir -p "$HOOKS_DIR" "$STATE_DIR"

if [[ ! -f "$MODE_FILE" ]]; then
    log "Initializing mode to SAFE"
    run sh -c "echo SAFE > '$MODE_FILE'"
else
    log "Mode file exists: $(cat "$MODE_FILE")"
fi

log "Setting global git hooksPath"
run git config --global core.hooksPath "$HOOKS_DIR"

# ========= VERIFY =========
CURRENT_HOOKS_PATH="$(git config --global core.hooksPath || true)"
[[ "$CURRENT_HOOKS_PATH" == "$HOOKS_DIR" ]] \
    || die "Failed to set core.hooksPath"

log "HooksPath verified: $CURRENT_HOOKS_PATH"

# ========= INSTALL git-brandmauer-mode =========
MODE_SCRIPT_SRC="$(cd "$(dirname "$0")" && pwd)/git-brandmauer-mode"
MODE_SCRIPT_DST="$LOCAL_BIN/git-brandmauer-mode"

if [[ -f "$MODE_SCRIPT_SRC" ]]; then
    log "Installing git-brandmauer-mode"
    run mkdir -p "$LOCAL_BIN"
    run cp "$MODE_SCRIPT_SRC" "$MODE_SCRIPT_DST"
    run chmod +x "$MODE_SCRIPT_DST"

    if ! echo "$PATH" | grep -q "$LOCAL_BIN"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        warn "$LOCAL_BIN was not in PATH."
        warn "Restart your shell or run: source ~/.bashrc"
    fi

    log "git-brandmauer-mode installed at $MODE_SCRIPT_DST"
else
    warn "git-brandmauer-mode script not found, skipping installation"
fi

# ========= INSTALL WRAPPER =========
if $INSTALL_WRAPPER; then
    log "Installing git UX wrapper"

    [[ -f "$WRAPPER_SRC" ]] \
        || die "Wrapper source not found: $WRAPPER_SRC"

    run mkdir -p "$LOCAL_BIN"

    if [[ -e "$WRAPPER_DST" && $FORCE_WRAPPER == false ]]; then
        die "git already exists in $LOCAL_BIN (use --force-wrapper)"
    fi

    run install -m 0755 "$WRAPPER_SRC" "$WRAPPER_DST"

    if ! echo "$PATH" | grep -q "$LOCAL_BIN"; then
        if ! $ADD_PATH; then
            warn "$LOCAL_BIN is not in PATH"
            warn "Add this to your shell config:"
            warn "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        else
            log "PATH will be active after restarting the shell"
        fi

        log "git wrapper installed at $WRAPPER_DST"
    fi
fi


if $INSTALL_WRAPPER && $ADD_PATH; then
    add_path
fi

if command -v git >/dev/null; then
    log "git resolved to: $(command -v git)"
fi

# ========= DONE =========
log "git-brandmauer installation complete"
log "Restart your shell to activate git UX wrapper"
log "You can enable full access with: echo OPEN > ~/.git-security/state/mode"
echo "[INFO] Current mode: $(cat "$MODE_FILE")"