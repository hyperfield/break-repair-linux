# Create Boot-Safe Labfstab Mount

This lab is a bridge between basic boot configuration and storage-backed boot
problems. It uses a loop-backed filesystem so you can practice persistent
mounting without repartitioning a real disk.

## Prerequisites

- Use a disposable RH-compatible VM snapshot and run the lab as root.
- Know that a loop device lets Linux treat a regular file as a block device,
  usually as `/dev/loopN`.
- Know the basic structure of an `/etc/fstab` line: source, mount point,
  filesystem type, options, dump, and fsck fields.
- Be comfortable with `UUID=` style mounts and why they are usually safer than
  device names.
- Know the purpose of `nofail`: it allows boot to continue even if the mount is
  unavailable.
