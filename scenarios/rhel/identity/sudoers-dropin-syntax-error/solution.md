# Sudoers Drop-In Syntax Error

1. Run `visudo -cf /etc/sudoers` to confirm there is a syntax problem.
2. Inspect the files under `/etc/sudoers.d/`.
3. Correct the malformed `NOPASSWD` rule or remove the broken drop-in.
4. Re-run `visudo -cf /etc/sudoers` until it exits cleanly.
