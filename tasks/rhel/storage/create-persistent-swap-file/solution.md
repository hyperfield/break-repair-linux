# Create Persistent Swap File

1. Create `/swap.lab` with a size of `128 MiB`.
2. Restrict permissions to `0600`.
3. Initialize the file for swap and activate it.
4. Add a persistent `/etc/fstab` entry for the swap file.
5. Verify with `swapon --show`, `stat`, and `grep /etc/fstab`.
