# Missing Crashkernel Kernel Arg

Ticket: kernel crash dump reservation must be configured persistently for future
boots.

Target state:

- the default boot entry includes `crashkernel=256M`
- the change is saved in the bootloader configuration, not only on the running
  kernel command line
