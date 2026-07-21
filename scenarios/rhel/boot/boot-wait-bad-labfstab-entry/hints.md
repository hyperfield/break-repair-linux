# Boot Wait Bad Labfstab Entry

- The issue is in saved startup configuration, not the current kernel.
- Compare the `fstab` line with the real filesystem UUID.
- Noncritical mounts should not be allowed to block boot indefinitely.
