# Fstab Loopback UUID Mismatch

This repair lab takes the loop-backed filesystem idea from the boot task and
turns it into a realistic `fstab` troubleshooting exercise.

## Prerequisites

- Use a disposable RH-compatible VM snapshot and run the lab as root.
- Be comfortable identifying loop devices with `losetup` and filesystem UUIDs
  with `blkid`.
- Know how `/etc/fstab` uses `UUID=` sources for persistent mounts.
- Expect this to be a repair exercise: the problem is not only reading the file,
  but confirming that the corrected mount actually works.
