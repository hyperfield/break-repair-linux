# Initramfs Omits Loop Driver

Ticket: this VM needs loop-device support available in the current initramfs.
Repair the boot configuration so the running kernel's initramfs contains the
`loop` driver again.

Target state:

- dracut configuration no longer omits the `loop` driver
- the initramfs for the running kernel has been rebuilt
- `lsinitrd` shows the `loop` driver in the current initramfs
