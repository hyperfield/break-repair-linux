# Create XFS Logical Volume

1. Inspect `labvg` and confirm there is enough free space.
2. Create a `96 MiB` logical volume named `lvlogs`.
3. Format `/dev/labvg/lvlogs` as XFS.
4. Mount it on `/mnt/lvlogs` and add a persistent `/etc/fstab` entry.
5. Verify with `lvs`, `blkid`, `findmnt`, and the saved mount configuration.
