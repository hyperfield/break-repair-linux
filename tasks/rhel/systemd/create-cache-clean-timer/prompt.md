# Create Cache Clean Timer

Create a script and matching systemd timer with this target state:

- script path: `/usr/local/bin/lab-cache-clean.sh`
- service unit: `lab-cache-clean.service`
- timer unit: `lab-cache-clean.timer`
- the service is a oneshot unit that runs the script
- the timer uses `OnBootSec=1min` and `OnUnitActiveSec=10min`
- the timer is enabled and active

The script should write a timestamp to `/var/tmp/lab-cache-clean.stamp`.
