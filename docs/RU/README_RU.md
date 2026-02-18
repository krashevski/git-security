# git_security

A set of scripts for secure Git management and network access control when working with repositories.

## Description

`git_security` helps:

- Enable or disable the network when needed.
- Check the network status before changing the password.
- Log security-related actions.

## Operational Scripts

- `./panic.sh` — the main script that controls network enablement and disablement and password changes.

## Installation

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
./bin/panic.sh
```
Logs are created in the ./logs directory.

## Notes

* Scripts were tested in the home environment (~/.scripts/git_security).
* Can also be used in test mode by changing the log paths and status.

## License

MIT

## Author

Vladislav Krashevski
