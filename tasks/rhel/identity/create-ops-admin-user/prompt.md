# Create Ops Admin User

Create a local support account with the following target state:

- user name: `labops`
- primary group: `labops`
- supplementary group: `wheel`
- login shell: `/bin/bash`
- password aging: minimum `1`, maximum `90`, warning `7`
- sudo rule in `/etc/sudoers.d/labops-restart-sshd`

The sudo rule must allow only this command as `root` without a password:

```text
/usr/bin/systemctl restart sshd
```
