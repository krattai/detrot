#!/bin/bash
#
# manages ctrl folder content
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
#

AEBL_TEST="/home/pi/.aebltest"
AEBL_SYS="/home/pi/.aeblsys"
IHDN_TEST="/home/pi/.ihdntest"
IHDN_SYS="/home/pi/.ihdnsys"
TEMP_DIR="/home/pi/tmp"

T_STO="/run/shm"
T_SCR="/run/shm/scripts"

LOCAL_SYS="${T_STO}/.local"
NETWORK_SYS="${T_STO}/.network"
OFFLINE_SYS="${T_STO}/.offline"

# NEW_PL="/home/pi/.newpl"
# PLAYLIST="/home/pi/.playlist"

# AEBL_TEST="/home/pi/.aebltest"
# AEBL_SYS="/home/pi/.aeblsys"
# IHDN_TEST="/home/pi/.ihdntest"
# IHDN_SYS="/home/pi/.ihdnsys"

# MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')

cd $HOME

while [ ! -f "${HOME}/ctrl/reboot" ]; do

    if [ ! -f "${HOME}/ctrl/Welcome.txt" ] && [ ! -f "${OFFLINE_SYS}" ]; then
        if [ -f "${LOCAL_SYS}" ]; then
            wget -N -nd -w 3 -P $HOME/ctrl --limit-rate=50k http://192.168.200.6/files/Welcome.txt &
        else
            wget -N -nd -w 3 -P $HOME/ctrl --limit-rate=50k http://192.168.200.6/files/Welcome.txt &
        fi
    fi

    if [ -f "${HOME}/ctrl/noauto" ]; then
        rm "${HOME}/ctrl/noauto"
        touch "${HOME}/.noauto"
        touch "${HOME}/ctrl/reboot"
    fi

    if [ -f "${HOME}/ctrl/auto" ]; then
        rm "${HOME}/ctrl/auto"
        rm "${HOME}/.noauto"
        touch "${HOME}/ctrl/reboot"
    fi

    if [ -f "${HOME}/ctrl/halt" ]; then
        touch "${HOME}/ctrl/reboot"
    fi

    sleep 1s

done

rm $HOME/ctrl/reboot

if [  -f "${HOME}/ctrl/halt" ]; then
    rm "${HOME}/ctrl/halt"

    sleep 1s
    sudo halt &
else
    sleep 1s
    sudo reboot &
fi

exit 0
