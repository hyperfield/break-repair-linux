# Broken Lab API Unit

1. Inspect the service status and logs to confirm startup failure.
2. Review the unit definition with `systemctl cat lab-api.service`.
3. Correct `ExecStart` so it points to `/usr/local/bin/lab-api.sh`.
4. Reload systemd, then enable and start the service again.
5. Confirm the service stays active and produces `/var/tmp/lab-api.heartbeat`.
