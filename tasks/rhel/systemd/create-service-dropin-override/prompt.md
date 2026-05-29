# Create Service Drop-In Override

The preparation script creates a base unit named `lab-sleeper.service`.

Create a systemd drop-in override so the target state is:

- `Restart=on-failure`
- `RestartSec=30s`
- the service is enabled
- the service is started successfully

Do not replace the main unit file. Use a drop-in.
