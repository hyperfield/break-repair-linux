# Sudoers Drop-In Syntax Error

- Always validate sudoers with `visudo -cf` instead of guessing.
- On RHEL systems, a broken file in `/etc/sudoers.d/` can invalidate the whole policy.
