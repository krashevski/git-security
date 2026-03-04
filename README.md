# git-security

A set of scripts for secure Git management and network access control when working with repositories.

## System Layout (v1.0 Stable)

### Overview

brandmauer is a system-level security tool designed for Ubuntu-based environments.
The filesystem layout follows principles compatible with the Filesystem Hierarchy Standard and typical Ubuntu conventions (ecosystem by Canonical Ltd.).

Version 1.0 defines a **stable and fixed directory structure**.
This layout will not change in future minor releases.

## Installation Paths

### 1. CLI Entry Point
```bash
/usr/local/bin/brandmauer
```

- Single executable entry point
- Acts as dispatcher
- Contains no business logic

### 2. Core System Library
```bash
/usr/local/lib/brandmauer/
```

Internal structure:
```bash
lib/brandmauer/
├── core/        # base utilities, logging, shared functions
├── git/         # git-brandmauer subsystem
├── net/         # net-security subsystem
├── hooks/       # git hook templates
├── ui/          # menu, output formatting, colors
└── config.sh    # global configuration
```

### Stability Guarantee (v1.0)
The following are considered stable:
Directory name brandmauer
Location `/usr/local/lib/brandmauer`
Subdirectories:
* `core`
* `git`
* `net`
* `hooks`
* `ui`
Future modules may be added, but existing paths will not change.

### 3. Shared Data (Optional)
```bash
/usr/local/share/brandmauer/
```

Reserved for:
* templates
* static assets
* documentation snippets
This directory may not exist if unused.

### 4. User State Directory
```bash
$HOME/.git-security/
```

Stores:
* repository modes (SAFE / HARD)
* registered repositories list
* runtime state
User data is never removed without confirmation.
This location is stable and part of the public system design.

## Architectural Model

The internal flow:
```bash
CLI → Core → Git / Net → Hooks
```

Where:
* CLI = interface layer
* Core = shared logic
* Git / Net = functional subsystems
* Hooks = repository enforcement layer

## Security Model (v1.0)

### Overview
brandmauer implements a local repository-level command control layer for Git operations.
Its purpose is to reduce the risk of accidental or unsafe remote operations in repositories hosted on GitHub and managed locally via Git.
The system works per repository and enforces security modes that either allow or restrict potentially dangerous commands.

### Core Concept
Each registered local repository has an assigned security mode:
`OPEN` — remote operations are allowed
`SAFE` — selected remote operations are blocked
The mode is stored locally and enforced automatically.

### Controlled Commands
In SAFE mode, the following Git commands are restricted:
* `git push`
* `git pull`
* `git fetch`
* `git rebase`
* `git merge`
These commands are considered potentially dangerous because they:
* modify remote history
* synchronize remote changes
* rewrite commit history
* merge external state into local branches

### Enforcement Layer

Security enforcement is implemented through:
* repository-level control logic
* Git hook integration (where applicable)
* command interception mechanisms
The protection applies per registered repository, not globally.
This allows:
* strict protection for critical repositories
* flexible operation for development repositories

## Mode Behavior

### OPEN Mode
* All Git commands operate normally.
* No restrictions are applied.

### SAFE Mode
* Controlled commands are blocked.
* The user receives a clear message explaining the restriction.
* Local operations (add, commit, status, etc.) remain unaffected.

### Scope of Protection
brandmauer operates:
* only on the local machine
* only for registered repositories
* only at the Git command level
It does not:
* modify GitHub server settings
* interfere with authentication
* replace Git itself
* enforce remote-side policies

### Design Principles
1. Local-first security
2. Per-repository control
3. Minimal intrusion
4. Explicit mode awareness
5. User-controlled enforcement

### Threat Model (Practical)
The system is designed to mitigate:
* accidental git push to protected branches
* unintended history rewrites
* impulsive remote synchronization
* workflow mistakes during sensitive development phases
It is not intended to defend against:
* malicious system-level attacks
* compromised user accounts
* server-side breaches

## Net-Security Subsystem

The net module is an integral part of the system and is not optional in v1.0.
Included tools:
* panic.sh
* burn-zip-archives.sh
* passwd_offline.sh
* net_check.sh
* net-pause.sh
These tools are considered core security utilities and are part of the system design.

## Upgrade Policy

Minor updates (v1.x) will not change filesystem layout.
Major version changes (v2.0+) may introduce structural changes.
Install and uninstall scripts rely on this layout.

## Design Philosophy

brandmauer is a system-level security layer for:
* Git repository control
* Network state control
* Emergency security actions
It is intended for local Ubuntu-based machines and is not designed for mobile or cross-platform deployment.

## Notes

* The scripts were tested in a home environment (~/.scripts/git_security).

## License

MIT

## Author

Vladislav Krashevsky, ChatGPT support