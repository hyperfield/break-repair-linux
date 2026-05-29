# RH-Compatible Exercise Catalog

This first content set adds 30 exercises for Rocky Linux, RHEL, and similar
systems.

## Tasks

| Category | Slug | Focus |
| --- | --- | --- |
| boot | `set-default-multi-user-target` | default systemd boot target |
| boot | `add-serial-console-kernel-arg` | persistent serial console kernel arg |
| boot | `add-crashkernel-reserve` | persistent crashkernel kernel arg |
| boot | `rebuild-initramfs-with-loop-driver` | dracut config and initramfs rebuild |
| boot | `create-boot-safe-labfstab-mount` | boot-safe `fstab` mount options |
| identity | `create-ops-admin-user` | local user, aging, sudoers |
| permissions | `create-shared-engineering-directory` | SGID and default ACLs |
| networking | `create-static-dummy-profile` | NetworkManager static config |
| storage | `create-xfs-logical-volume` | LVM, XFS, persistent mounts |
| storage | `create-persistent-swap-file` | swap file creation and persistence |
| services | `deploy-healthcheck-service` | oneshot systemd service |
| systemd | `create-cache-clean-timer` | timers and unit relationships |
| security | `persist-httpd-selinux-context` | persistent SELinux file contexts |
| packages | `create-disabled-baseos-repo-file` | repo file definition |
| systemd | `create-service-dropin-override` | drop-in overrides |

## Scenarios

| Category | Slug | Fault |
| --- | --- | --- |
| boot | `default-target-set-to-rescue` | rescue target saved as default boot target |
| boot | `missing-serial-console-kernel-arg` | required serial console arg removed |
| boot | `missing-crashkernel-kernel-arg` | required crashkernel arg removed |
| boot | `initramfs-omits-loop-driver` | dracut config omits a needed module |
| boot | `boot-wait-bad-labfstab-entry` | boot-sensitive `fstab` entry is unsafe and wrong |
| services | `sshd-invalid-dropin` | invalid sshd config fragment |
| identity | `sudoers-dropin-syntax-error` | malformed sudoers policy |
| permissions | `wrong-home-owner-and-mode` | broken home directory ownership |
| systemd | `broken-lab-api-unit` | bad ExecStart in a custom service |
| storage | `fstab-loopback-uuid-mismatch` | wrong UUID in `/etc/fstab` |
| security | `selinux-label-drift` | live labels differ from persistent rule |
| networking | `broken-dummy-profile` | wrong NetworkManager profile values |
| networking | `bad-repo-hosts-entry` | incorrect static hostname mapping |
| identity | `expired-backup-user` | expired local account |
| systemd | `masked-cache-clean-timer` | masked timer unit |

## Notes

- Storage exercises use loopback-backed lab artifacts and can be reset with the
  included cleanup scripts.
- Boot exercises may alter saved kernel arguments, default targets, dracut
  configuration, and initramfs images. Run them from VM snapshots.
- SELinux exercises assume SELinux is not disabled and that `semanage` is
  available.
- NetworkManager exercises assume the host uses NetworkManager.
- Some boot exercises assume `grubby`, `dracut`, and `lsinitrd` are installed.
