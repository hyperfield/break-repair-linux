# Cron Job Wrong User

1. Inspect `/etc/cron.d/lab-cron-report`.
2. Notice that the job runs as `labmissing`.
3. Change the user field to `root` while keeping the schedule and command.
4. Confirm the script is executable.
