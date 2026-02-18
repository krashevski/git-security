#!/usr/bin/env bash
set -euo pipefail

echo "=== Network status ==="
nmcli networking
echo

echo "=== Active connections ==="
nmcli device status

