# Cron Job Wrong User

Ticket: a simple cron job should run every five minutes and write a timestamp to
`/var/tmp/lab-cron-report.stamp`, but its `/etc/cron.d` entry names a user that
does not exist.

Target state:

- `/usr/local/bin/lab-cron-report.sh` exists and is executable
- `/etc/cron.d/lab-cron-report` exists
- the cron job runs as `root`
- the schedule remains `*/5 * * * *`
- the command remains `/usr/local/bin/lab-cron-report.sh`
