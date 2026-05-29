# Add Crashkernel Reserve

Configure the default boot entry so the kernel command line includes this exact
argument:

```text
crashkernel=256M
```

Treat this as a persistent bootloader change for future boots.
