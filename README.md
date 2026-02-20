# git-security

A set of scripts for secure Git management and network access control when working with repositories.

## Description

`GIT-SECURITY` helps:

- Check network status.
- Enable or disable the network, change the password if necessary in emergency mode.
- Log security-related actions.

## Operational Scripts

- `./panic.sh` — controls network enablement and disablement and password changes for PANIC MODE (emergency shutdown).
- `./network-pause.sh` - сentral network pause controller.
- `./net_status.sh` - network status.
- `./burn_zip_archives.sh` - burning ZIP archives to CD/DVD.
- `./menu.sh` - GIT-SECURITY control menu.

## GIT-SECURITY Brandmauer scripts

- `git-pull.sh` - GIT-SECURITY Brandmauer
- `git-push.sh` - GIT-SECURITY Brandmauer
- `git-rebase.sh` - GIT-SECURITY Brandmauer
- `giy-state.sh` - git operation definition

## Dependencies

`git-security` uses shared functions from the [`shared-lib`](https://github.com/krashevski/shared-lib) library.

For the project to work, you need to include `shared-lib` in the `shared-lib` directory.

### Installing `shared-lib` via a submodule

If you are cloning the project for the first time:

```bash
git clone --recurse-submodules https://github.com/krashevski/git-security.git
```

## Installation git-security

1. Clone the repository:

```bash
git clone https://github.com/krashevski/git_security.git
```

2. Change to the project directory:
```bash
cd git_security
```

3. Grant execute permissions for the scripts:
```bash
chmod +x *.sh
```

## Usage

Run the main script:
```bash
./bin/menu.sh
```
Logs are created in the ./logs directory.

## Notes

* Scripts were tested in the home environment (~/.scripts/git_security).
* Can also be used in test mode by changing the log paths and status.

## License

MIT

## Author

Vladislav Krashevski with support ChatGPT