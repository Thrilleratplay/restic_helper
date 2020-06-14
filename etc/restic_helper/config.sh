#!/bin/sh

################################################################################
## RESTIC SERVER VARIABLES
################################################################################

export REMOTE_HOST="REMOTE_HOST_NAME_OR_IP"
export REMOTE_PATH="/path/to/backup/"

# How many backups to keep.
export RETENTION_DAYS=14
export RETENTION_WEEKS=16
export RETENTION_MONTHS=18
export RETENTION_YEARS=3
export KEEP_LIMIT=20

# What to backup, and what to not
export BACKUP_PATHS="/"

# How many concurrent processes can Restic use at any one time
export MAX_PROCESSES=1
