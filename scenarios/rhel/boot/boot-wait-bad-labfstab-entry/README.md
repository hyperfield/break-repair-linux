# Boot Wait Bad Labfstab Entry

This lab shows how a storage mistake can turn into a boot reliability problem.
The mount target itself is not complicated; the important part is making the
configuration safe for future boots.

## Prerequisites

- Use a disposable RH-compatible VM snapshot and run the lab as root.
- Be comfortable with loop-backed filesystems, `UUID=` mounts, and basic
  `fstab` troubleshooting.
- Know that a bad `fstab` entry can delay boot, drop the system into emergency
  mode, or create long waits for devices that are optional or missing.
- Know why `nofail` and a short `x-systemd.device-timeout` matter for boot-safe
  mounts.
