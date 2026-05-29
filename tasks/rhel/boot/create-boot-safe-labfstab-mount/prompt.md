# Create Boot-Safe Labfstab Mount

The preparation script creates a loop-backed XFS filesystem.

Create a persistent mount for it with this target state:

- mount point: `/mnt/bootlab`
- use the filesystem UUID in `/etc/fstab`
- filesystem type: `xfs`
- options include `defaults,nofail,x-systemd.device-timeout=1s`
- the filesystem is mounted now

The point of the exercise is to configure an `fstab` entry that is safer for boot.
