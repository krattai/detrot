#!/bin/bash
#
# manages ctrl folder content
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
#

LOCAL_SYS="/home/pi/.local"
NETWORK_SYS="/home/pi/.network"
OFFLINE_SYS="/home/pi/.offline"

# NEW_PL="/home/pi/.newpl"
# PLAYLIST="/home/pi/.playlist"

# AEBL_TEST="/home/pi/.aebltest"
# AEBL_SYS="/home/pi/.aeblsys"
# IHDN_TEST="/home/pi/.ihdntest"
# IHDN_SYS="/home/pi/.ihdnsys"

# MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')

cd $HOME

while [ ! -f "${HOME}/ctrl/reboot" ]; do

    wait 5

done

rm $HOME/ctrl/reboot

sudo reboot &

exit 0
