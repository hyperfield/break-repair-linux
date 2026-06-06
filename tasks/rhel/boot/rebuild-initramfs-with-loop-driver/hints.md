# Rebuild Initramfs With Loop Driver

- This is a dracut configuration task, not a modprobe task.
- Verification inspects the saved dracut config and the current initramfs image.
- A successful reboot does not mean the task failed; most systems do not need
  `loop` to mount the real root filesystem during early boot.
