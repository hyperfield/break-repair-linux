# Missing Serial Console Kernel Arg

1. Inspect the default boot entry with `grubby --info DEFAULT`.
2. Restore the missing `console=ttyS0,115200n8` kernel argument.
3. Verify the saved boot entry contains the argument again.
