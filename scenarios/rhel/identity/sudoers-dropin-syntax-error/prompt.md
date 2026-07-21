# Sudoers Drop-In Syntax Error

Ticket: sudo policy validation is failing after a lab drop-in was added. Restore
valid sudoers syntax so administrative sudo checks can pass again.

Target state:

- `visudo -cf /etc/sudoers` exits successfully
- no sudoers drop-in leaves the policy in a syntactically invalid state
