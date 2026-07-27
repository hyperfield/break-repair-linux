# Cron Job Wrong User

- Files under `/etc/cron.d/` include a user field after the five schedule fields.
- If that user does not exist, cron cannot run the command as intended.
