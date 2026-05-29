# Create Boot-Safe Labfstab Mount

1. Identify the loop-backed filesystem UUID.
2. Create `/mnt/bootlab`.
3. Add a persistent `/etc/fstab` entry using `xfs` and the required options.
4. Mount the filesystem and verify the live mount plus the saved configuration.
