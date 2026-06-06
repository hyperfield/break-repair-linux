# Initramfs Omits Loop Driver

This repair lab is the troubleshooting version of the initramfs task. Instead
of building the right image from scratch, you have to spot the conflicting
dracut configuration and regenerate the image correctly.

## Prerequisites

- Use a disposable RH-compatible VM snapshot and run the lab as root.
- Know the basic early-boot flow: kernel, initramfs, discovery of the real root
  filesystem, then handoff to the real system.
- Know that `dracut` builds the initramfs image and that config snippets under
  `/etc/dracut.conf.d/` can change what drivers are included.
- Know that `lsinitrd` inspects the built image itself, which is different from
  merely reading the saved dracut config.
- A successful reboot does not automatically prove that `loop` is present in
  initramfs; some systems do not need it for their own root filesystem.
