# Create Shared Engineering Directory

Build a shared directory for an engineering team.

Target state:

- group `labeng` exists
- directory `/srv/labshare` exists
- owner is `root:labeng`
- mode is `2770`
- the directory has a default ACL so members of `labeng` get `rwx` on new files and directories
