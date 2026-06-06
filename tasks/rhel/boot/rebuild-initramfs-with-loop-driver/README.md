# Rebuild Initramfs With Loop Driver

This task is about making a kernel driver available during early boot, not
just after the system is already up.

On RH-compatible systems, the initramfs is the temporary userspace the kernel
uses before the real root filesystem is mounted. `dracut` builds that image.
If a driver is missing from the initramfs, loading it later with `modprobe`
does not help with anything that needed that driver earlier in the boot path.

The `loop` driver is a useful training example because it is easy to verify in
the initramfs image with `lsinitrd`, but it also maps to real admin work:
understanding when a module must be present in the boot image and knowing how
to rebuild that image safely.

## Prerequisites

- Use a disposable RH-compatible VM snapshot and run the lab as root.
- Know the basic early-boot flow: kernel, initramfs, discovery of the real root
  filesystem, then handoff to the real system.
- Know that `dracut` is the RH-family tool that builds initramfs images.
- Know that `lsinitrd` inspects the built image itself rather than only reading
  the config that might influence a future build.
- It helps if you already understand loop-backed filesystems from the related
  `fstab` labs, because then the `loop` driver is much less abstract.

## Why This Matters

Admins sometimes change dracut configuration and assume the job is finished.
It is not. The saved config only affects future initramfs builds. The running
system keeps booting from the current image until that image is regenerated.

This task reinforces three ideas:

- some boot dependencies must exist inside the initramfs itself
- dracut configuration and initramfs contents are related, but not the same
- verification should inspect the built image, not just the config file

## Real-World Motivation

In real environments, this kind of work comes up when:

- a custom boot path depends on a module that a default initramfs did not
  include
- an admin adds a dracut snippet during troubleshooting and forgets to rebuild
  the initramfs
- a kernel or dracut update changes which drivers are included by default
- a VM, appliance, rescue image, or lab environment boots from image files or
  other workflows that rely on loop devices during early boot
- teams are validating that a generated initramfs contains everything required
  before rolling the image to multiple systems

## About The `loop` Driver

The `loop` driver lets Linux treat a regular file as a block device. That is
common when working with filesystem image files, ISO images, and lab or
appliance-style disk images.

A standard server often does not need `loop` to boot, so a system may reboot
normally even if the driver is absent from the initramfs. That does not make
the task irrelevant. The point is to practice controlling initramfs contents
deliberately and verifying the result correctly.

## What Success Looks Like

For this task, success means:

- `/etc/dracut.conf.d/90-lab-loop.conf` explicitly adds `loop`
- the initramfs for the running kernel has been rebuilt
- `lsinitrd` shows that the rebuilt image now contains the `loop` module

That is the skill being practiced: changing boot-time driver inclusion in a
repeatable way.
