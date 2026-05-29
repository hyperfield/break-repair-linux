# Persist HTTPD SELinux Context

The preparation script creates `/srv/labsite/index.html`.

Configure SELinux so the target state is:

- content under `/srv/labsite` is labeled for read-only HTTPD access
- the mapping is persistent, not a one-time temporary label change
- the current files under `/srv/labsite` have already been relabeled correctly

Assume SELinux is enforcing or permissive, not disabled.
