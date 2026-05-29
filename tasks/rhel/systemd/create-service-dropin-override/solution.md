# Create Service Drop-In Override

1. Inspect the base unit with `systemctl cat lab-sleeper.service`.
2. Create a drop-in under `/etc/systemd/system/lab-sleeper.service.d/`.
3. Override the restart policy and delay exactly as requested.
4. Reload systemd, enable the service, and start it.
5. Verify with `systemctl show` and `systemctl cat`.
