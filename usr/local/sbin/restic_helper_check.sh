#!/usr/bin/env bash
# Check my backup with  restic to for errors.
# This script is typically run by: /etc/systemd/system/restic-check.{service,timer}

# shellcheck disable=SC1091
source /etc/restic_helper/config.sh
source /usr/local/sbin/restic_helper_shared.sh

# Exit on failure, pipe failure
set -e -o pipefail

# Clean up lock if we are killed.
# If killed by systemd, like $(systemctl stop restic), then it kills the whole cgroup and all it's subprocesses.
# However if we kill this script ourselves, we need this trap that kills all subprocesses manually.
trap exit_hook INT TERM

restic_wrapper "check --verbose"
