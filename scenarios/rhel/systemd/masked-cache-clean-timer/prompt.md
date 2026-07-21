# Masked Cache Clean Timer

Ticket: the lab cache-clean timer should be enabled and running on its intended
schedule, but it is not currently firing.

Target state:

- `lab-cache-clean.timer` exists
- the timer has `OnBootSec=2min`
- the timer has `OnUnitActiveSec=15min`
- the timer is enabled
- the timer is active
