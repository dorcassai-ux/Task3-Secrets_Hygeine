# Automated Infrastructure Scripting & Secrets Hygiene

A small automation toolkit: a Bash script that backs up a directory on a schedule, and a Python script that counts errors in a log file. Secrets stay in environment variables and out of Git. Built as **Task 3** of the Elevvo Pathways Cloud & DevOps Engineering Internship.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Scheduling with Cron](#scheduling-with-cron)
- [Secrets Handling](#secrets-handling)
- [Verification](#verification)
- [Screenshots](#screenshots)
- [Troubleshooting](#troubleshooting)
- [Author](#author)

## Features

- Compresses a target directory into a date-stamped `.tar.gz` archive
- Fail-fast Bash (`set -euo pipefail`) so errors never pass silently
- Runs unattended every day at midnight through cron, with output and errors logged
- Python log parser that counts `ERROR` lines and handles a missing file with `try/except`
- No hardcoded credentials: the API key is read from the environment
- `.gitignore` keeps secrets, logs and archives out of version control

## Project Structure

```
.
├── backup.sh        # Bash backup script
├── log_parser.py    # Python log parser
├── cron.txt         # Crontab entry (daily at midnight)
├── test-folder/     # Small folder for testing the backup
├── .gitignore       # Excludes .env, *.tar.gz, *.log, __pycache__/, backup.log
└── README.md
```

## Prerequisites

- Linux (tested on Ubuntu)
- Bash and `tar`
- Python 3
- `cron`

## Usage

### Backup script

```bash
chmod +x backup.sh
./backup.sh <directory-to-back-up>
```

If no directory is given, `/var/www/html` is used. Archives are written to `~/backups/` as `backup-YYYY-MM-DD_HH-MM-SS.tar.gz`.

Example:

```bash
./backup.sh test-folder
# Backup created: /home/<user>/backups/backup-2026-11-09_20-22-33.tar.gz
```

### Log parser

The parser reads `app.log` from the current directory and needs `API_KEY` in the environment.

```bash
export API_KEY="my-fake-key-123"   # use a fake value for practice
python3 log_parser.py
# Total ERRORs found: 3
```

Sample `app.log`:

```
2026-11-09 10:00:01 INFO Server started
2026-11-09 10:05:13 ERROR Database connection failed
2026-11-09 10:12:30 ERROR Timeout while calling payment API
2026-11-09 10:20:19 ERROR Disk usage above 90%
```

## Scheduling with Cron

The exact entry is stored in `cron.txt`. Adjust the user name and path to match your system:

```
0 0 * * * /bin/bash /home/dorcas-sai/task3-backup/backup.sh >> /home/dorcas-sai/task3-backup/backup.log 2>&1
```

| Part | Meaning |
|---|---|
| `0 0 * * *` | Every day at 00:00 |
| `/bin/bash`, script path | Absolute paths, because cron runs with a minimal environment |
| `>> backup.log` | Append output to a log file |
| `2>&1` | Send errors to the same log |

Install and check:

```bash
crontab cron.txt
crontab -l
```

## Secrets Handling

- No password, key or token is stored in the code or the commit history.
- Credentials are read from environment variables (`os.environ.get("API_KEY")`). The script exits with a clear message if the variable is missing.
- `.gitignore` excludes `.env`, archives, logs and Python cache files.

## Verification

| Check | Command | Expected result |
|---|---|---|
| Backup is created | `./backup.sh test-folder` | `Backup created: ...tar.gz` |
| Archive exists | `ls -lh ~/backups` | A new date-stamped archive |
| Parser needs the key | `python3 log_parser.py` (key not set) | `API_KEY not set in environment` |
| Parser counts errors | `export API_KEY=...` then `python3 log_parser.py` | `Total ERRORs found: 3` |
| Cron is installed | `crontab -l` | The midnight entry |
| Cron command works | run the cron line by hand, then `cat backup.log` | `Backup created` message |
| Nothing secret is tracked | `git status` | No `.env`, logs or archives listed |

## Screenshots

Creating and testing the backup script:

![Backup script test](screenshots/Screenshot_2026-11-09_221311.png)

Archives created, and the log parser run before and after setting the key:

![Archives and parser](screenshots/Screenshot_2026-11-09_221356.png)

Fixed script run, and the cron entry installed (`crontab -l`), run by hand and logged in `backup.log`:

![Fixed run](screenshots/Screenshot_2026-11-10_062946.png)

![Cron installed and logged](screenshots/Screenshot_2026-11-10_062850.png)

Git status before the first commit:

![Git status](screenshots/Screenshot_2026-11-09_221627.png)

## Troubleshooting

| Symptom | Cause | Resolution |
|---|---|---|
| `unexpected EOF while looking for matching quote` | Missing closing quote in the script | Fix the quote and run again |
| A folder literally named `BACKUP_DIR` appears | Variable written without `$` | Use `"$BACKUP_DIR"` |
| `crontab -l` shows `no crontab` | `cron.txt` is only a file until it is installed | Run `crontab cron.txt` |
| Cron job does nothing | Wrong user or path in the entry | Use the real absolute paths |
| `API_KEY not set in environment` | Variable not exported | `export API_KEY=...` |

## Author

**Dorcas Torshie Sai**
GitHub: [@dorcassai-ux](https://github.com/dorcassai-ux)
