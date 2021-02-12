#!/usr/bin/env bash

# Make backup my system with restic to restic server
# This script is typically run by: /etc/systemd/system/restic-helper-backup.{service,timer}

# shellcheck disable=SC1091
source /etc/restic_helper/config.sh
source /usr/local/sbin/restic_helper_shared.sh

# Exit on failure, pipe failure
set -e -o pipefail

# NOTE start all commands in background and wait for them to finish.
# Reason: bash ignores any signals while child process is executing and thus my trap exit hook is not triggered.
# However if put in subprocesses, wait(1) waits until the process finishes OR signal is received.
# Reference: https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash
trap exit_hook INT TERM

###############################################################################
########################## Execute Restic #####################################
###############################################################################

# Remove locks from other stale processes to keep the automated backup running.
restic_wrapper "unlock"

# Do the backup!
# See restic-backup(1) or http://restic.readthedocs.io/en/latest/040_backup.html
# --one-file-system makes sure we only backup exactly those mounted file systems specified in $BACKUP_PATHS, and thus not directories like /dev, /sys etc.
# --tag lets us reference these backups later when doing restic-forget.
restic_wrapper "backup --one-file-system $TAG_PARAM $BACKUP_EXCLUDES_PARAM $BACKUP_PATHS"

# Dereference and delete/prune old backups.
# See restic-forget(1) or http://restic.readthedocs.io/en/latest/060_forget.html
# --group-by only the tag and path, and not by hostname. This is because I create a B2 Bucket per host, and if this hostname accidentially change some time, there would now be multiple backup sets.
restic_wrapper "forget $TAG_PARAM \
              --prune \
              --keep-last $KEEP_LIMIT \
              --keep-daily $RETENTION_DAYS \
              --keep-weekly $RETENTION_WEEKS \
              --keep-monthly $RETENTION_MONTHS \
              --keep-yearly $RETENTION_YEARS"

# Remove locks.
restic_wrapper "unlock"
