# Initramfs Omits Loop Driver

1. Inspect the dracut snippets under `/etc/dracut.conf.d/`.
2. Remove or correct the snippet that omits the `loop` driver.
3. Rebuild the initramfs for the running kernel.
4. Verify the `loop` driver is present again with `lsinitrd`.
