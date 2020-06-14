#!/usr/bin/env bash


# Send notification to all users with x11 sessions. Useful for sending notifications
# from scripts that run as root.
#
#
# EXAMPLES:
#
# $> notify-send-all-users.sh Hello!
#
# $> notify-send-all-users.sh 'No running by the pool' --icon=dialog-warning
#
# $> notify-send-all-users.sh 'This text in bold' 'You failed to fail successfully' --icon=dialog-error
#
#
# Sources:
#
# https://stackoverflow.com/questions/28195805/running-notify-send-as-root/49533938#49533938
# https://forums.bunsenlabs.org/viewtopic.php?id=2685


function notify-send() {
  local display
  local user
  local uid

  # list of open senssions
  sessions=$(loginctl --no-legend list-sessions | sed -e 's/^ *//g'| cut -f1 -d " ")

  for sessionid in $sessions;
  do
    # If user is logged in to X11
    if [[ $(loginctl --property Type --value show-session "$sessionid") = 'x11' ]]; then
      # determine username, uid and display the used by user
      user=$(loginctl --property Name --value show-session "$sessionid");
      uid=$(loginctl --property User --value show-session "$sessionid");
      display=$(loginctl --property Display --value show-session "$sessionid");

      # display notification to that user
      sudo -u "$user" DISPLAY="$display" DBUS_SESSION_BUS_ADDRESS=unix:path="/run/user/$uid/bus" notify-send "$@"
    fi
  done
}

notify-send "$@"
