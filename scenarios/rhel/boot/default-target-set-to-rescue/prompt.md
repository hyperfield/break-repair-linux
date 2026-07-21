# Default Target Set To Rescue

Ticket: this server should boot normally into the multi-user command-line
environment. It should not enter rescue mode by default on the next boot.

Target state:

- the saved default systemd target is `multi-user.target`
