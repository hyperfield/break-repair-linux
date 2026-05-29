# Create Shared Engineering Directory

1. Create the `labeng` group.
2. Create `/srv/labshare`, set ownership to `root:labeng`, and set mode `2770`.
3. Add a default ACL giving the `labeng` group `rwx`.
4. Verify with `stat -c '%U:%G %a' /srv/labshare` and `getfacl -cp /srv/labshare`.
