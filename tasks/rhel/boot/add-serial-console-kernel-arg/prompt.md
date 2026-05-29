# Add Serial Console Kernel Arg

Configure the default boot entry so the kernel command line includes this exact
argument:

```text
console=ttyS0,115200n8
```

Treat this as a persistent bootloader change for future boots.
