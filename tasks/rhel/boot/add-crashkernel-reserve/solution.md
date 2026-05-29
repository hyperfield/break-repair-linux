# Add Crashkernel Reserve

1. Inspect the default boot entry with `grubby --info DEFAULT`.
2. Add `crashkernel=256M` persistently to the installed kernels.
3. Verify the saved boot entry now contains the required argument.
