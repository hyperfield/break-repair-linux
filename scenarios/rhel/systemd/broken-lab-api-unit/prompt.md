# Broken Lab API Unit

Ticket: `lab-api.service` should run continuously and start automatically at
boot, but it is currently failing.

Target state:

- `lab-api.service` exists
- the service starts `/usr/local/bin/lab-api.sh`
- the service is enabled
- the service is active
- the service creates `/var/tmp/lab-api.heartbeat`
