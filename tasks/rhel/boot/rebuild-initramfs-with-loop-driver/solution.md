# Rebuild Initramfs With Loop Driver

1. Create `/etc/dracut.conf.d/90-lab-loop.conf` with an `add_drivers` setting for `loop`.
2. Rebuild the initramfs for the running kernel.
3. Verify the config file and inspect the initramfs contents with `lsinitrd`.
