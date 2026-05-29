# Bad Repo Hosts Entry

1. Query the hostname with `getent hosts repo-rhel-lab.example.test`.
2. Inspect `/etc/hosts` and find the incorrect static mapping.
3. Replace it with the correct address `192.0.2.50`.
4. Re-run `getent hosts` to confirm the repaired resolution path.
