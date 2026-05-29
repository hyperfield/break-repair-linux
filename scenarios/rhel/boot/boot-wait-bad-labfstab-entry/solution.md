# Boot Wait Bad Labfstab Entry

1. Inspect `/etc/fstab` and identify the `/mnt/bootrepair` entry.
2. Find the real UUID of the loop-backed filesystem.
3. Replace the bad UUID and add `nofail,x-systemd.device-timeout=1s`.
4. Mount the filesystem and verify the persistent configuration is now boot-safe.
