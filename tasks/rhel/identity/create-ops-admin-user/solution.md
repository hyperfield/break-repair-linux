# Create Ops Admin User

1. Create the `labops` user with a local home directory and `/bin/bash`.
2. Ensure the user's primary group is `labops` and add the user to `wheel`.
3. Set aging values so the minimum is `1`, the maximum is `90`, and the warning period is `7`.
4. Create `/etc/sudoers.d/labops-restart-sshd` with mode `0440` and the exact allowed command.
5. Confirm the result with `id`, `getent passwd`, `chage -l`, and `visudo -cf /etc/sudoers`.
