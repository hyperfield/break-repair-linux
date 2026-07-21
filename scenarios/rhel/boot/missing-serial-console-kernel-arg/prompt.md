# Missing Serial Console Kernel Arg

Ticket: the VM must provide kernel and login output on the first serial console
for environments that depend on `ttyS0`. A normal VGA or graphical boot may
still look healthy.

Target state:

- the default boot entry includes `console=ttyS0,115200n8`
- the change is saved in the bootloader configuration for future boots
