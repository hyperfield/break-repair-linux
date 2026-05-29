# Persist HTTPD SELinux Context

1. Inspect the current label on `/srv/labsite/index.html`.
2. Create a persistent file-context rule for `/srv/labsite(/.*)?` using `httpd_sys_content_t`.
3. Apply the new labeling to the current files.
4. Verify with `matchpathcon` and `ls -Z`.
