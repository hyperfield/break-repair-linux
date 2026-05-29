# Persist HTTPD SELinux Context

- Verification checks both the default path mapping and the current live label.
- If you only change the current label, one of those two checks will still fail.
