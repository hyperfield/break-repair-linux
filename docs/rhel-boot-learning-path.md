# RH-Compatible Boot Learning Path

This path is meant for someone who knows Linux administration basics but wants
the boot-specific pieces to click in a more deliberate order.

Use a clean VM snapshot for each lab. Boot and storage exercises change saved
state such as the default target, kernel arguments, `/etc/fstab`, dracut
config, and initramfs images.

## Suggested Order

1. `tasks/rhel/boot/set-default-multi-user-target`
2. `tasks/rhel/boot/add-serial-console-kernel-arg`
3. `tasks/rhel/boot/add-crashkernel-reserve`
4. `tasks/rhel/boot/create-boot-safe-labfstab-mount`
5. `scenarios/rhel/storage/fstab-loopback-uuid-mismatch`
6. `scenarios/rhel/boot/boot-wait-bad-labfstab-entry`
7. `tasks/rhel/boot/rebuild-initramfs-with-loop-driver`
8. `scenarios/rhel/boot/initramfs-omits-loop-driver`

## Selector Map

| Order | Type | Category | Title | `--id` value |
| --- | --- | --- | --- | --- |
| 1 | task | boot | `Set Default Multi-User Target` | `set-default-multi-user-target` |
| 2 | task | boot | `Add Serial Console Kernel Arg` | `add-serial-console-kernel-arg` |
| 3 | task | boot | `Add Crashkernel Reserve` | `add-crashkernel-reserve` |
| 4 | task | boot | `Create Boot-Safe Labfstab Mount` | `create-boot-safe-labfstab-mount` |
| 5 | scenario | storage | `Fstab Loopback UUID Mismatch` | `fstab-loopback-uuid-mismatch` |
| 6 | scenario | boot | `Boot Wait Bad Labfstab Entry` | `boot-wait-bad-labfstab-entry` |
| 7 | task | boot | `Rebuild Initramfs With Loop Driver` | `rebuild-initramfs-with-loop-driver` |
| 8 | scenario | boot | `Initramfs Omits Loop Driver` | `initramfs-omits-loop-driver` |

## 1. Set Default Multi-User Target

Why first:
- It introduces the idea of saved next-boot state without involving storage,
  kernel arguments, or initramfs.

To launch the lab, run:

```bash
sudo ./scripts/select-exercise --tasks --id set-default-multi-user-target
```

After the lab, run:

```bash
systemctl get-default
readlink -f /etc/systemd/system/default.target
systemctl list-unit-files --type=target | grep -E 'multi-user|graphical|rescue'
```

Look for:
- `multi-user.target` as the saved default target
- the symlink under `/etc/systemd/system/default.target` resolving to
  `multi-user.target`
- the distinction between a saved default and other available targets

## 2. Add Serial Console Kernel Arg

Why now:
- It builds on the same "saved for the next boot" idea, but moves from
  `systemd` target state to persistent kernel command-line state.

To launch the lab, run:

```bash
sudo ./scripts/select-exercise --tasks --id add-serial-console-kernel-arg
```

After the lab, run:

```bash
grubby --default-kernel
grubby --info DEFAULT | sed -n '/^args=/p'
cat /proc/cmdline
```

Look for:
- `console=ttyS0,115200n8` in the default boot entry
- the difference between the saved default boot entry and the currently running
  kernel command line in `/proc/cmdline`

## 3. Add Crashkernel Reserve

Why now:
- It reinforces the same bootloader skill with a more ops-oriented kernel
  parameter.

To launch the lab, run:

```bash
sudo ./scripts/select-exercise --tasks --id add-crashkernel-reserve
```

After the lab, run:

```bash
grubby --info DEFAULT | sed -n '/^args=/p'
cat /proc/cmdline
grep -R '^options ' /boot/loader/entries 2>/dev/null | grep crashkernel
```

Look for:
- `crashkernel=256M` in the saved default boot entry
- the same "saved next boot" versus "current running kernel" distinction

## 4. Create Boot-Safe Labfstab Mount

Why now:
- It makes loop devices concrete before you revisit them in an initramfs
  context.
- It also introduces the idea that storage configuration can affect boot
  reliability.

To launch the lab, run:

```bash
sudo ./scripts/select-exercise --tasks --id create-boot-safe-labfstab-mount
```

After the lab, run:

```bash
findmnt /mnt/bootlab
blkid "$(findmnt -no SOURCE /mnt/bootlab)"
grep '/mnt/bootlab' /etc/fstab
```

Look for:
- a mounted source such as `/dev/loopN` behind `/mnt/bootlab`
- an `fstab` entry that uses `UUID=...`
- `nofail,x-systemd.device-timeout=1s` in the options
- the mount being active now

## 5. Fstab Loopback UUID Mismatch

Why now:
- It reuses the same loop-backed storage idea, but in repair mode instead of
  create-and-configure mode.

To launch the lab, run:

```bash
sudo ./scripts/select-exercise --scenarios --id fstab-loopback-uuid-mismatch
```

After the lab, run:

```bash
findmnt /mnt/labfstab
blkid "$(findmnt -no SOURCE /mnt/labfstab)"
grep '/mnt/labfstab' /etc/fstab
```

Look for:
- the active loop device that backs the lab image
- an `fstab` line whose UUID matches the real filesystem UUID
- a working persistent mount instead of just a corrected text file

## 6. Boot Wait Bad Labfstab Entry

Why now:
- It connects loop-backed filesystems directly to boot safety and boot delay
  behavior.

To launch the lab, run:

```bash
sudo ./scripts/select-exercise --scenarios --id boot-wait-bad-labfstab-entry
```

After the lab, run:

```bash
findmnt /mnt/bootrepair
blkid "$(findmnt -no SOURCE /mnt/bootrepair)"
grep '/mnt/bootrepair' /etc/fstab
```

Look for:
- the corrected UUID in `/etc/fstab`
- `nofail,x-systemd.device-timeout=1s` in the mount options
- the mount being usable now, with configuration that is less likely to block
  boot later

## 7. Rebuild Initramfs With Loop Driver

Why now:
- By this point `loop` no longer feels abstract. You have already used
  loop-backed filesystems and seen why boot-sensitive configuration matters.
- Now you can focus on the difference between a saved dracut config file and
  the actual built initramfs image.

To launch the lab, run:

```bash
sudo ./scripts/select-exercise --tasks --id rebuild-initramfs-with-loop-driver
```

After the lab, run:

```bash
cat /etc/dracut.conf.d/90-lab-loop.conf
lsinitrd /boot/initramfs-$(uname -r).img | grep 'loop\.ko'
modinfo loop | sed -n '1,12p'
```

Look for:
- `add_drivers+=" loop "` in the dracut snippet
- `loop.ko` inside the built initramfs image
- the distinction between "the module exists on disk" and "the module is
  present in initramfs"

## 8. Initramfs Omits Loop Driver

Why last:
- It is the same concept as the previous lab, but now you have to diagnose and
  repair a broken dracut configuration.

To launch the lab, run:

```bash
sudo ./scripts/select-exercise --scenarios --id initramfs-omits-loop-driver
```

After the lab, run:

```bash
grep -R 'loop' /etc/dracut.conf.d
lsinitrd /boot/initramfs-$(uname -r).img | grep 'loop\.ko'
lsinitrd /boot/initramfs-$(uname -r).img | head
```

Look for:
- no conflicting `omit_drivers+=" loop "` snippet left in place
- `loop.ko` back inside the initramfs image
- growing comfort with the idea that initramfs is an archive you can inspect,
  not a black box

## Concept Map

Keep these ideas in mind as you move through the path:

- A loop device is a way to treat a regular file as a block device.
- `/etc/fstab` is persistent mount configuration that systemd uses during boot.
- `grubby` changes saved bootloader entries for future boots.
- `initramfs` is the temporary early-boot root filesystem the kernel uses
  before the real root is mounted.
- `dracut` builds that initramfs image on RH-family systems.
- `lsinitrd` lets you inspect what actually ended up inside the built image.
