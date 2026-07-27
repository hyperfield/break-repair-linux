# Enabled Broken Lab Repo

Ticket: package operations are trying to use a temporary lab repository that is
not available anymore. Keep the repository definition for later review, but stop
DNF/YUM from using it by default.

Target state:

- `/etc/yum.repos.d/lab-broken.repo` exists
- the repo id is `lab-broken`
- the repository is disabled with `enabled=0`
- `gpgcheck=0` remains set
