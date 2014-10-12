#!/bin/bash
# runs updates
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
#
# This file will be superceded by the l-ctrl file as far as
# control of the system, as l-ctrl will be a cron job.  This
# script may become depricated, although it might continue a
# useful, future function for loose processes that are outside
# the scope of the l-ctrl function.
#
# This is control file that can change from time to time on admin
# desire.  This script is in addition to the getupdt.sh script
# only because the getupdt.sh script is assumed to be static
# where this one could contain a process which could update the
# getupdt.sh script if desired.
#
# Eventually, it would be nice to have this script create
# log or file to indicate that it completed successfully
# this would be the last command before a the script exits
# on a success rather than a fail exit
#
# There should be a control that allows system to be put into a
# live or a test condition.  Should be in at least in a cron job but
# eventually should be a daemon.
#
# This script is the one called from the getupdt.sh script and should
# probably make immediate determination between IHDN and AEBL systems
# and call respective scripts.
#
# This is the first script from clean bootup.  It should immediately
# put something to screen and audio so that people know it is working,
# and it should then loop that until it get's a .sysready lockfile.
#
# Utilize good bash methodologies as per:
# http://www.davidpashley.com/articles/writing-robust-shell-scripts/#id2382181
#
# This script should probably loop and simply watch for .sysready and ! .sysready states.

# this was used to set keyboard LED for detector hardware to know
# not to process

# xset led 3

# set to home directory

LOCAL_SYS="/home/pi/.local"
NETWORK_SYS="/home/pi/.network"
OFFLINE_SYS="/home/pi/.offline"
NOTHING_NEW="/home/pi/.nonew"
NEW_PL="/home/pi/.newpl"
FIRST_RUN_DONE="/home/pi/.firstrundone"
AEBL_TEST="/home/pi/.aebltest"
AEBL_SYS="/home/pi/.aeblsys"
IHDN_TEST="/home/pi/.ihdntest"
IHDN_SYS="/home/pi/.ihdnsys"
IPw0=$(ip addr show wlan0 | awk '/inet / {print $2}' | cut -d/ -f 1)
MACw0=$(ip link show wlan0 | awk '/ether/ {print $2}')
IPe0=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f 1)
MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')

CRONCOMMFILE="/home/pi/.tempcron"
 
 
cd $HOME

# if [ -f "${NEW_PL}" ]; then
#    rm .nonew
#    sudo reboot

#     if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
#         echo "Setting up stored playlist." >> log.txt
#         echo $(date +"%T") >> log.txt
#     fi
#     rm .playlist
#     cp .newpl .playlist
#     rm .playlistnew
# else
    # make playlist

#     if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
#         echo "Creating new playlist." >> log.txt
#         echo $(date +"%T") >> log.txt
#     fi
#     scripts/./playlist.sh ~/pl/*.mp4

    # scripts/./playlist.sh ~/pl/*.mp3

#     cp .playlist .newpl
# fi

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
    echo "Starting the following playlist set." >> log.txt
    cat .playlist >> log.txt
    echo $(date +"%T") >> log.txt
fi

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ] && [ ! -f "${NOTHING_NEW}" ]; then
    echo "Setting system to not check updates with .nonew" >> log.txt
    echo $(date +"%T") >> log.txt
    touch .nonew
fi

# play through the playlist
if [ -f "${HOME}/.playlist" ]; then
    scripts/./process_playlist.sh
fi

exit
