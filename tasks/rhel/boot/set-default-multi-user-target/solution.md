# Set Default Multi-User Target

1. Inspect the current default target with `systemctl get-default`.
2. Change the saved default target to `multi-user.target`.
3. Verify the result with `systemctl get-default` and the `default.target` symlink.
