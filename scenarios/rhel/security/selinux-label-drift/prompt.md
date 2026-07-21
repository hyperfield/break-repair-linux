# SELinux Label Drift

Ticket: `/srv/labsite` is configured as read-only HTTPD content, but the live
SELinux labels have drifted from the persistent policy.

Target state:

- SELinux is not disabled
- `/srv/labsite/index.html` exists
- the persistent file-context mapping for `/srv/labsite(/.*)?` expects
  `httpd_sys_content_t`
- the current label on `/srv/labsite/index.html` is also `httpd_sys_content_t`
