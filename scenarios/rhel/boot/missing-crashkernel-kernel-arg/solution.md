# Missing Crashkernel Kernel Arg

1. Inspect the default boot entry with `grubby --info DEFAULT`.
2. Restore the missing `crashkernel=256M` kernel argument.
3. Verify the saved boot entry contains the argument again.
