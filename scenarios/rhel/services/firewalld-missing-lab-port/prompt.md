# Firewalld Missing Lab Port

Ticket: a lab service is expected to accept TCP connections on port `8080`, but
the host firewall is not allowing that port.

Target state:

- firewalld is running
- port `8080/tcp` is allowed in the active firewall configuration
- port `8080/tcp` is also allowed permanently so the rule survives reloads
