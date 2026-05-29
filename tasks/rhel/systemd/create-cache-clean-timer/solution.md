# Create Cache Clean Timer

1. Create `/usr/local/bin/lab-cache-clean.sh` and make it executable.
2. Create a oneshot `lab-cache-clean.service` unit that runs the script.
3. Create `lab-cache-clean.timer` with `OnBootSec=1min` and `OnUnitActiveSec=10min`.
4. Reload systemd, enable the timer, and start it.
5. Verify with `systemctl cat`, `systemctl is-enabled`, and `systemctl is-active`.
