#!/usr/bin/env bash
# =============================================================
# net_check.sh - script for automatic network status check
# -------------------------------------------------------------
# Purpose:
#   for use lib/net.sh
# =============================================================

set -euo pipefail

if nmcli -t -f STATE device | grep -q '^connected$'; then
    exit 0
else
    exit 1
fi
