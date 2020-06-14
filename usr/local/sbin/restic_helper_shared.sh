#!/usr/bin/env bash

# shellcheck disable=SC1091
source /etc/restic_helper/config.sh

export BACKUP_EXCLUDES_PARAM="--exclude-file=/etc/restic_helper/restic_excludes.txt"
export BACKUP_TAG=systemd.timer
export TAG_PARAM="--tag $BACKUP_TAG"

REMOTE_HOST_PARAM="-r sftp:$REMOTE_HOST:$REMOTE_PATH"
PASS_FILE_PARAM="--password-file=/etc/restic_helper/restic_pw.txt"

# Clean up lock if we are killed.
# If killed by systemd, like $(systemctl stop restic), then it kills the whole cgroup and all it's subprocesses.
# However if we kill this script ourselves, we need this trap that kills all subprocesses manually.
exit_hook() {
  echo "In exit_hook(), being killed" >&2
  jobs -p | xargs kill
  restic "$REMOTE_HOST_PARAM" unlock "$PASS_FILE_PARAM" &
}

# Stanardize Restic command call and error handling
restic_wrapper() {
  RESTIC_CMD="restic $REMOTE_HOST_PARAM $PASS_FILE_PARAM $1"
  ERROR=$( { GOMAXPROCS=$MAX_PROCESSES $RESTIC_CMD & } 2>&1 )
  wait $!

  if [ -n "$ERROR" ] && [ "$1" != "unlock" ]; then
    notify-send-all-users.sh 'Restic backup error' "$ERROR" --icon=dialog-warning
    exit 1;
  fi
}
