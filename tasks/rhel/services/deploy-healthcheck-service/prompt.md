# Deploy Healthcheck Service

Create a systemd oneshot service with this target state:

- script path: `/usr/local/bin/lab-healthcheck.sh`
- unit name: `lab-healthcheck.service`
- the service runs the script and remains in the successful `active` state after it completes
- the service is enabled at boot
- starting the service creates `/var/tmp/lab-healthcheck.ok`

The script should write `ok` and the current date into `/var/tmp/lab-healthcheck.ok`.
