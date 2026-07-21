# Boot Wait Bad Labfstab Entry

Ticket: `/mnt/bootrepair` is a noncritical lab filesystem. It should mount when
the lab disk is available, but the VM must still boot normally if that disk is
missing or slow to appear.

Right now the saved mount configuration is unsafe: a bad `/etc/fstab` entry can
make boot wait too long or drop into emergency mode. Repair the saved mount
configuration and mount the filesystem now.

Target state:

- `/mnt/bootrepair` is an XFS filesystem backed by the lab loop device
- `/etc/fstab` has exactly one entry for `/mnt/bootrepair`
- the entry uses the real filesystem UUID, not a placeholder UUID
- the entry includes `nofail` and `x-systemd.device-timeout=1s`
- `/mnt/bootrepair` is mounted now
