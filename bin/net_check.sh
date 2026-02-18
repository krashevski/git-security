#!/usr/bin/env bash
set -euo pipefail

if nmcli -t -f STATE device | grep -q '^connected$'; then
    exit 0
else
    exit 1
fi
