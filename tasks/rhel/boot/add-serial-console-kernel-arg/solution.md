# Add Serial Console Kernel Arg

1. Inspect the default boot entry with `grubby --info DEFAULT`.
2. Add `console=ttyS0,115200n8` persistently to the installed kernels.
3. Verify the saved boot entry now contains the required argument.
