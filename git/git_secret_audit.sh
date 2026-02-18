#!/usr/bin/env bash
# =============================================================
# git_secret_audit.sh — быстрый аудит секретов, поиск потенциальных утечек
# -------------------------------------------------------------
# Использование git_secret_audit.sh
:<<'DOC'

DOC
# =============================================================

set -euo pipefail

echo "[GIT-SECURITY] Auditing for secrets..."
echo

PATTERNS=(
    "token"
    "secret"
    "password"
    "PRIVATE KEY"
)

for p in "${PATTERNS[@]}"; do
    echo "Searching: $p"
    git grep -n "$p" || true
    echo
done
