# Changelog

All notable changes to this project will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and the project follows [Semantic Versioning](https://semver.org/).

---

## [1.1.0] - 2027-03-08

### Added
- Scripts: `automatic_safe.sh`, `close_active_repos.sh`, `activity.sh`, `policy.sh`, `state.sh`
- UI: `settings_menu.sh`, updated `git-menu.sh`
- Brandmauer hook: `brandmauer_hook.sh`
- `Close Active Repositories` for quickly SAFE all OPEN/NORMAL repositories

### Changed
- Updated pre-hooks (`pre-fetch`, `pre-push`, `pre-rebase`)
- Logging via `logging.sh`
- Integration with `brandmauer doctor` for Automatic SAFE diagnostics and repository status

### Removed
- Old pre-hooks (`pre-merge-commit`, `pre-* hooks`)

### Fixed
- Fixed proper closing of all repositories
- Improved idle checking in `automatic_safe.sh`

## [1.0.4] - 2026-03-05

### Added

Initial stable release of **Brandmauer**.

Features:

- Git security firewall for repositories
- SAFE / NORMAL / OPEN modes
- Per-repository mode control
- Global mode fallback
- Git hooks enforcement:
  - pre-push
  - pre-fetch
  - pre-rebase
  - pre-merge-commit
- Logging of blocked operations
- CLI utilities:
  - brandmauer
  - brandmauer-git
  - brandmauer-net
  - brandmauer-mode
- Global Git hooksPath installation
- Bash completion support
- System installer

### Security

- Fail-safe SAFE mode
- Protection against recursive git calls
- Centralized policy engine (common.sh)

### Notes

This release represents the first stable version of Brandmauer.

## [1.0.0] - 2026-03-04
### Added
- **Smart hook installer** `smart-install-hooks.sh` for automatically updating only changed Git hooks
- **Interactive menu** for managing repositories and modes (SAFE, NORMAL, OPEN)
- **Network control scripts** (`net/`) for network checking, pausing connections, and emergency stopping
- **Logging system** in `~/.local/share/brandmauer/logs/` for network and security events
- **Modular directory structure**:
- `LIB_DIR` — static scripts (/usr/local/lib/brandmauer)
- `SECURITY_ROOT` — state and local hooks (~/.git-security)
- `LOG_DIR` — logs (~/.local/share/brandmauer/logs)
- `NET_DIR` — network scripts

### Changed
- `network_menu()` now returns to the main menu instead of exiting the script
- `burn-zip-archives` block fixed: correctly handles empty input and outputs debug information
- Arithmetic comparisons in the menu have been changed to safe strings, preventing crashes on empty input
- Pre-push hook improved: repository mode check, logging, and handling the absence of `common.sh`

### Fixed
- Errors when running `git push` related to the absence of `common.sh` and incorrect repository modes
- Synchronize repository state with menus and hooks

---

### Future Plans
- Add hook backup before updates
- Expand network scripts and Panic Mode automation
- Ability to centrally update all scripts Brandmauer
