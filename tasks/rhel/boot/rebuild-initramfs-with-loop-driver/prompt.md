# Rebuild Initramfs With Loop Driver

Configure dracut so the current initramfs includes the `loop` kernel driver.

Target state:

- dracut config file: `/etc/dracut.conf.d/90-lab-loop.conf`
- the config explicitly adds the `loop` driver
- the initramfs for the running kernel has been rebuilt and now contains that driver
- a normal reboot is still an acceptable outcome on most lab VMs; verify the
  result with `lsinitrd` or `verify.sh`, not by expecting boot failure
