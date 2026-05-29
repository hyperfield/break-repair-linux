# Create Disabled BaseOS Repo File

Create a YUM/DNF repository definition at `/etc/yum.repos.d/lab-baseos.repo` with this exact target state:

```ini
[lab-baseos]
name=Lab BaseOS
baseurl=http://repo.lab.example.com/rhel/9/BaseOS/x86_64/os/
enabled=0
gpgcheck=0
```
