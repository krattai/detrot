#!/bin/bash
# This script preps the pi for use on the AEBL framework
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
#
# Useage:

LOCAL_SYS="/home/pi/.local"
NETWORK_SYS="/home/pi/.network"
OFFLINE_SYS="/home/pi/.offline"
AEBL_SYS="/home/pi/.aeblsys"

TEMP_DIR="/home/pi/tempdir"
MP3_DIR="/home/pi/mp3"
MP4_DIR="/home/pi/mp4"
PL_DIR="/home/pi/pl"
CTRL_DIR="/home/pi/ctrl"
BIN_DIR="/home/pi/bin"

USER=`whoami`
CRONLOC=/var/spool/cron/crontabs
# CRONCOMMFILE=/tmp/cron_comm_file.sh
CRONCOMMFILE="${HOME}/testcron.sh"
CRONGREP=$(crontab -l | cat )

IPe0=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f 1)
MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')

cd $HOME

# Discover network availability
#

ping -c 1 8.8.8.8

if [ $? -eq 0 ]; then
    touch .network
    echo "Internet available."
else
    rm .network
fi

ping -c 1 192.168.200.6

if [[ $? -eq 0 ]]; then
    touch .local
    echo "Local network available."
else
    rm .local
fi

if [ ! -f "${LOCAL_SYS}" ] && [ ! -f "${NETWORK_SYS}" ]; then
    touch .offline
    echo "No network available."
    exit 1
else
    rm .offline
fi

# set sys type scripts
if [ -f "$HOME/aeblsys" ]; then
    systype="create-asys.sh"
    sysloc="1t3ejk4iyzm07u6"
    rm $HOME/aeblsys
fi

if [ -f "$HOME/idetsys" ]; then
    systype="create-idet.sh"
    sysloc="kkb5wq8p7wjgtfw"
    rm $HOME/idetsys
fi

if [ -f "$HOME/irotsys" ]; then
    systype="create-irot.sh"
    sysloc="0whnl7rum9m2gvk"
    rm $HOME/irotsys
fi

export PATH=$PATH:${BIN_DIR}:$HOME/scripts

# Get necessary AEBL files
# this should also be used if there's anything else that was missed
# in the initial AEBL fw setup, inclding packages or config
# where the subsequent scripts should only setup unique types
#

if [ ! -f "${OFFLINE_SYS}" ]; then

    if [ -f "${LOCAL_SYS}" ]; then

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/${systype}

    else

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/${sysloc}/${systype}"

    fi

fi

chmod 777 $HOME/scripts/./${systype}

# set up typeand end gracefully
$HOME/scripts/./${systype} &

rm $HOME/scripts/create-aebl.sh
rm $HOME/scripts/create-atyp.sh

exit
