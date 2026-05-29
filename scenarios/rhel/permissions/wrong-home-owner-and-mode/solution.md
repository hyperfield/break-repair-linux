# Wrong Home Owner And Mode

1. Confirm the user exists and inspect `/home/labanalyst`.
2. Restore ownership to `labanalyst:labanalyst`.
3. Restore secure permissions on the home directory.
4. Re-check with `stat -c '%U:%G %a' /home/labanalyst`.
