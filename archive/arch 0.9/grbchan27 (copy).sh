#!/bin/bash
# Shell script to grab channel video files off server
#
# Copyright (C) 2014 IHDN, Uvea I. S., Kevin Rattai
#

LOCAL_SYS="/home/pi/.local"
NETWORK_SYS="/home/pi/.network"
OFFLINE_SYS="/home/pi/.offline"

IPe0=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f 1)
MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')

cd $HOME

touch .getchan27

# check network
#
# this will fail if local network but no internet
# also fails if network was available but drops

if [ ! -f "${OFFLINE_SYS}" ] && [ -f "${NETWORK_SYS}" ]; then

    if [ ! -f "${HOME}/mp4/OilChangeDemo720.mp4" ] && [ ! -f "${HOME}/pl/OilChangeDemo720.mp4" ]; then

        curl -o "$HOME/mp4/OilChangeDemo720.mp4" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000027/OilChangeDemo720.mp4"

        touch .newchan27

    fi

#     The following will download and delete file

    curl -o "$HOME/chan27.m3u" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000027/chan27.m3u" -Q '-rm /home/videouser/videos/000027/chan27.m3u'

#  was using:
#
#     curl -o "$HOME/chan27.m3u" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000027/chan27.m3u"

    rm mychan

    cp chan27.m3u mychan

    GRAB_FILE="${HOME}/mychan"

    x=1

    mkdir tmp

    while [ $x == 1 ]; do
        # Sleep so it's possible to kill this
#         sleep 1

        # check file doesn't exist
        if [ ! -f "${GRAB_FILE}" ]; then
            echo "Playlist file ${GRAB_FILE} not found"
            continue
        fi
    
        touch .newchan27

        # Get the top of the playlist
        cont=$(cat "${GRAB_FILE}" | head -n1)
    
        # And strip it off the playlist file
        cat "${GRAB_FILE}" | tail -n+2 > "${GRAB_FILE}.new"
        mv "${GRAB_FILE}.new" "${GRAB_FILE}"

        # Skip if this is empty
        if [ -z "${cont}" ]; then
            echo "Playlist empty or bumped into an empty entry for some reason"

            # added by Kevin: exit clean if empty
            x=0

        fi

        clear
        echo
        echo "Getting ${cont} ..."
        echo

        curl -o "$HOME/pl/${cont}" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000027/${cont}"

        echo
        echo "File complete, continuing to next item."
        echo

    done
fi

if [ -f "${HOME}/.newchan27" ]; then
    $HOME/tmpdir_maintenance/mod_Twitter/./tcli.sh -c statuses_update -s "automagic #IHDNpi #Hyundai demo channel 27 updated." &
fi

rm .getchan27

# tput clear
exit 0
