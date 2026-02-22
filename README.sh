#!/usr/bin/env bash
# ==================================================================
# README.sh - git-security Project Description
# ------------------------------------------------------------

echo "========================================================="
echo " git_security - Security Tools"
echo "=========================================================="
echo
echo "Project Description:"
echo " git-security - toolkit Scripts for secure git management"
echo " and network access control when working with repositories."
echo
echo "Features:"
echo " - Network status check"
echo " - Network panic enable/disable and password change"
echo " - Security operation logging"
echo
echo "Current working scripts:"
echo " - bin/panic.sh — controls network enablement and disablement and password changes for PANIC MODE."
echo " - bin/network-pause.sh - сentral network pause controller."
echo " - bin/net-status.sh - network status."
echo " - bin/burn-zip-archives.sh - burning ZIP archives to CD/DVD."
echo " - bin/menu.sh - GIT-SECURITY control menu."
echo
echo "Git-brandmauer scripts"
echo " - bin/git - wrapper for testing git pull and git fetch"
echo " - hooks/common.sh - mode definition script"
echo " - hooks/enable_hooks.sh` - manual setup"
echo " - hooks/pre-fetch - git fetch hook trigger"
echo " - hooks/pre-push - git push hook trigger"
echo " - hooks/pre-rebase - git rebase hook trigger"
echo " - state/mode - status data"
echo " - menu/controlls.sh - commands to test"
echo
echo "Dependencies"
echo "git-security uses shared functions from the [`shared-lib`](https://github.com/krashevski/shared-lib) library."
echo "For the project to work, you need to include `shared-lib` in the `shared-lib` directory."
echo 
echo "Installing shared-lib via a submodule" 
echo "If you are cloning the project for the first time:"
echo "git clone --recurse-submodules https://github.com/krashevski/git-security.git"
echo
echo "Installation git-security and run:"
echo " 1) Clone the repository:"
echo "    git clone https://github.com/krashevski/git_security.git"
echo " 2) Change to the project directory:"
echo "    cd git_security"
echo " 3) Grant script execution permissions:"
echo "    chmod +x *.sh"
echo " 4) Run the main script:"
echo "    ./bin/menu.sh"
echo
echo "Notes:"
echo " - Scripts Tested in a home environment (~/.scripts/git_security)"
echo " - Logs are saved in ./logs"
echo
echo "License: MIT"
echo "Author: Vladislav Krashevsky"
echo "=================================================="
