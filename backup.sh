#!/bin/bash
set -euo pipefail

SOURCE_DIR="${1:-/var/ww/html}"
BACKUP_DIR="${HOME}/backups"
TIMESTAMP=$(date  +%Y-%m-%d_%H-%M-%S)

mkdir -p "BACKUP_DIR"
tar -czf "$BACKUP_DIR/backup-$TIMESTAMP.tar.gz" "$SOURCE_DIR"
echo "Backup created: $BACKUP_DIR/backup-$TIMESTAMP.tar.gz"
