# Missing Serial Console Kernel Arg

This scenario does not necessarily stop the machine from booting. It breaks
serial-console access for environments that depend on `ttyS0`.

1. Inspect the default boot entry with `grubby --info DEFAULT`.
2. Restore the missing `console=ttyS0,115200n8` kernel argument.
3. Verify the saved boot entry contains the argument again.
