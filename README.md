# Restic Helper
A stiped down version of [restic-systemd-automatic-backup](https://github.com/erikw/restic-systemd-automatic-backup) to automate [restic](https://restic.net/) backups using systemd and dbus notifications.

## Requirements
* Systemd based Linux system
* restic backup client and existing back up repo.
* libnotify


## Installation
1. Download or clone the repo.
2. `cd` to the directory and run `sudo make install`
3.  Edit config files
  * `/etc/restic_helper/config.sh` - Add hostname/IP and remote backup path.  Also modify back up retention limits and root backup path.
  * `/etc/restic_helper/restic_pw.txt` - Add your restic remote password
  * `/etc/restic_helper/restic_excludes.txt` - List of files and directories for restic to ignore
4. `systemctl start restic-helper-backup` and optionally `systemctl start restic-helper-check`
