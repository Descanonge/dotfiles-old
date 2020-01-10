#!/bin/bash
#Prints notification message, made to work while launched by cron

if [ ! -v DBUS_SESSION_BUS_ADDRESS ]; then
  pid=$(pgrep -u $LOGNAME cinnamon-session)
  eval "export $(\grep -z DBUS_SESSION_BUS_ADDRESS /proc/$pid/environ)"
fi

$HOME/.scripts/notify.sh "Pause" "Fais une pause enculé.e"
