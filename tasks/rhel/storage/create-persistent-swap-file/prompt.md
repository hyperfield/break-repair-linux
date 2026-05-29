# Create Persistent Swap File

Create and activate a persistent swap file with this target state:

- path: `/swap.lab`
- size: `128 MiB`
- permissions: `0600`
- active now
- configured in `/etc/fstab` so it survives reboot
