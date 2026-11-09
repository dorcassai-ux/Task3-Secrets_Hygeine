# Task 3: Automated Infrastructure Scripting & Secrets Hygiene

This project has a backup script and a log parser.
I used environment variables for secrets, no passwords in code.

## What This Does
- `backup.sh` - Creates a timestamped .tar.gz backup of a folder
- `log_parser.py` - Counts ERROR lines in app.log
- `cron.txt` - Runs backup daily at midnight
- `.gitignore` - Prevents secrets, logs, and backups from being committed

## How To Use

### Backup Script
```bash
chmod +x backup.sh
./backup.sh
./backup.sh /path/to/folder



