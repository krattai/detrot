#!/bin/bash
# runs on boot
#
# Copyright (C) 2014 - 2016 Uvea I. S., Kevin Rattai
#
# Carry out specific functions when asked to by the system
case "$1" in
  start)
    AUTOOFF_CHECK_FILE="/home/pi/.noauto"

#     sudo -u pi rm /home/pi/.playlist
#     sudo -u pi touch /home/pi/.playlist
#     mount -o exec,remount /run/shm
#     sudo -u pi mkdir /run/shm/scripts
#     sudo -u pi cp -p /home/pi/.scripts/* /run/shm/scripts
#     sudo -u pi /run/shm/scripts/./ctrlwtch.sh &

    if [ ! -f "${AUTOOFF_CHECK_FILE}" ]; then
        echo "${AUTOOFF_CHECK_FILE} not found, in auto mode."
        setterm -blank 1
        sudo -u ihdn /home/ihdn/scripts/./startup.sh &
    fi
    echo "Could do more here"
    ;;
  stop)
    echo "Stopping script bootup.sh"
    echo "Could do more here"
    ;;
  *)
    echo "Usage: /etc/init.d/bootup.sh {start|stop}"
    exit 1
    ;;
esac

exit 0
