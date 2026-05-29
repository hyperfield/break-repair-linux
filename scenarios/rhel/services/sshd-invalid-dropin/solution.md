# SSHD Invalid Drop-In

1. Confirm the failure with `sshd -t` or `systemctl status sshd`.
2. Inspect `/etc/ssh/sshd_config` and files under `/etc/ssh/sshd_config.d/`.
3. Remove or correct the invalid directive in `99-break-repair-invalid.conf`.
4. Re-run `sshd -t` until the configuration validates cleanly.

