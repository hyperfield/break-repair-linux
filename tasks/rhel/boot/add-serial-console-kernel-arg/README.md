# Add Serial Console Kernel Arg

This lab introduces persistent kernel command-line changes by adding a serial
console argument to the default boot entry.

## Prerequisites

- Use a disposable RH-compatible VM snapshot and run the lab as root.
- Be comfortable with the idea that bootloader changes are saved for future
  boots and may not change the currently running kernel immediately.
- Know that the kernel command line is a list of boot parameters passed in by
  the bootloader.
- It helps to know why serial consoles matter in practice: cloud VMs, hypervisor
  consoles, remote recovery, and systems without convenient local graphics.
