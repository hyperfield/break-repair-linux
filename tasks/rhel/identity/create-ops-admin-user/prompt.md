# Create Ops Admin User

Create a local support account with the following target state:

- user name: `labops`
- primary group: `labops`
- supplementary group: `wheel`
- home directory: `/home/labops`
- login shell: `/bin/bash`
- password aging: minimum `1`, maximum `90`, warning `7`
- no fixed account expiration date
- sudo rule file: `/etc/sudoers.d/labops-restart-sshd`
- sudo rule file mode: `0440`

The sudoers file must contain this exact rule:

```sudoers
labops ALL=(root) NOPASSWD: /usr/bin/systemctl restart sshd
```
