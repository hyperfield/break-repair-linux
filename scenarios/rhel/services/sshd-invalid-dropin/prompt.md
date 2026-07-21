# SSHD Invalid Drop-In

Ticket: SSHD configuration validation is failing after a local drop-in was
added. Repair the configuration so SSHD can be safely restarted.

Target state:

- `sshd -t` exits successfully
- no SSHD drop-in leaves an invalid directive in the effective configuration
