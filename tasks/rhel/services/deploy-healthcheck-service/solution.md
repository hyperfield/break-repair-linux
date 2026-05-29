# Deploy Healthcheck Service

1. Create `/usr/local/bin/lab-healthcheck.sh` and make it executable.
2. Build a `lab-healthcheck.service` unit that uses `Type=oneshot` and `RemainAfterExit=yes`.
3. Point `ExecStart` at the script, reload systemd, enable the service, and start it.
4. Verify with `systemctl show`, `systemctl is-enabled`, `systemctl is-active`, and the output file.
