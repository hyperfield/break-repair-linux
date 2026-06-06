# Boot

Boot tasks focus on saved startup configuration such as the default target,
kernel command-line arguments, initramfs content, and boot-safe `fstab`
entries.

These exercises touch boot-related state, but they are not all meant to make
the VM fail to boot. Some are verified by inspecting the saved configuration
or the rebuilt initramfs image after the system comes back up normally.

For a guided sequence that builds the related concepts gradually, see
`docs/rhel-boot-learning-path.md`.
