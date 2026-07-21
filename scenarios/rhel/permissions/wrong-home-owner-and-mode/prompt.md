# Wrong Home Owner And Mode

Ticket: user `labanalyst` cannot use their home directory securely. Restore the
home directory to the expected ownership and permissions.

Target state:

- user `labanalyst` exists
- `/home/labanalyst` is owned by `labanalyst:labanalyst`
- `/home/labanalyst` has mode `700`
