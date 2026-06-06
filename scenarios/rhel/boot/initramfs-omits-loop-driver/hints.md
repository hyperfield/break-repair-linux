# Initramfs Omits Loop Driver

- Check dracut configuration snippets before you rebuild anything.
- This scenario is fixed only after the initramfs image itself has been regenerated.
- The VM may still boot normally while this scenario is broken if `loop` is not
  required to reach the real root filesystem in initramfs.
