#!/bin/bash
# runs on boot
#
# Copyright (C) 2014 IHDN, Uvea I. S., Kevin Rattai
#
# Boot up also included the following changes from:
# http://blog.sheasilverman.com/2013/09/adding-a-startup-movie-to-your-raspberry-pi/
#
# You will need to edit your /boot/cmdline.txt file:
#
#    sudo nano /boot/cmdline.txt
#
# Add quiet to the end of the line. It will look something like this:
#
#    dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait quiet
#
# May wish to continue with the above and make a video splash, but
# in the event a static image is prefered, have currently gone with:
# http://www.edv-huber.com/index.php/problemloesungen/15-custom-splash-screen-for-raspberry-pi-raspbian
#
#
#
#! /bin/sh
# /etc/init.d/blah
#

# Some things that run always
# touch /var/lock/blah

# Carry out specific functions when asked to by the system
case "$1" in
  start)
    setterm -blank 1
    sudo -u pi rm /home/pi/.playlist
#    sudo -u pi touch /home/pi/.playlist
    sudo -u pi rm /home/pi/syncing
    sudo -u pi /home/pi/scripts/./getupdt.sh &
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
