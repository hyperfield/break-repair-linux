# Fstab Loopback UUID Mismatch

Ticket: the lab filesystem at `/mnt/labfstab` should mount persistently from its
loop-backed XFS filesystem, but the saved mount configuration does not match the
actual filesystem.

Target state:

- `/etc/fstab` has exactly one entry for `/mnt/labfstab`
- the entry uses the real UUID of the loop-backed filesystem
- the filesystem type is `xfs`
- `/mnt/labfstab` is mounted now
