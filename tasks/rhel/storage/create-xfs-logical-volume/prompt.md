# Create XFS Logical Volume

The preparation script creates a volume group named `labvg`.

Using that volume group, create this target state:

- logical volume name: `lvlogs`
- size: `384 MiB`
- filesystem: `XFS`
- mount point: `/mnt/lvlogs`
- persistent mount in `/etc/fstab`
