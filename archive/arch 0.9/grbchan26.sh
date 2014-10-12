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

touch .getchan26

# check network
#
# this will fail if local network but no internet
# also fails if network was available but drops

if [ ! -f "${OFFLINE_SYS}" ] && [ -f "${NETWORK_SYS}" ]; then

#     if [ ! -f "${HOME}/mp4/ArtMomentClean.mp4" ] && [ ! -f "${HOME}/pl/ArtMomentClean.mp4" ]; then

#         curl -o "$HOME/mp4/ArtMomentClean.mp4" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000026/ArtMomentClean.mp4"

#         touch .newchan26

#     fi

#     if [ ! -f "${HOME}/mp4/RAStennisMASre.mp4" ] && [ ! -f "${HOME}/pl/RAStennisMASre.mp4" ]; then
#         curl -o "$HOME/mp4/RAStennisMASre.mp4" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000026/RAStennisMASre.mp4"

#         touch .newchan26

#     fi

#     The following would download and delete file
#
#     curl -o "$HOME/chan26.m3u" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000027/chan26.m3u" -Q '-rm /home/videouser/videos/000027/chan26.m3u'

    rm index*

    # Check if not syncing
    # should append syncing to syncing file and dump it to dropbox

    if [ ! -f "${HOME}/syncing" ]; then
        echo "Currently not syncing." >> log.txt
        echo "Making running token."  >> log.txt
        echo $(date +"%T") >> log.txt

        touch "${HOME}/syncing"

        rm mychan

        curl -o "$HOME/chan26.m3u" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000026/chan26.m3u"

        cp chan26.m3u mychan

        rm chan26.m3u

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/vtm7naqg4sbq2wh/ihdn_tests.sh"

        GRAB_FILE="${HOME}/mychan"

        x=1

        if [ ! -d "tmp" ]; then
            mkdir tmp
        fi

        while [ $x == 1 ]; do
            # Sleep so it's possible to kill this
    #         sleep 1

            # check file doesn't exist
            if [ ! -f "${GRAB_FILE}" ]; then
                echo "Playlist file ${GRAB_FILE} not found"
                continue
            fi
    
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

#                 continue

            fi

            # Check that the file exists
    #         if [ ! -f "${cont}" ]; then
    #                 echo "Playlist entry ${cont} not found"
    #                 continue
    #         fi

            clear
            echo
            echo "Getting ${cont} ..."
            echo
            if [ ! -f "$HOME/mp4/${cont}" ]; then

    #         "${PLAYER}" ${PLAYER_OPTIONS} "${cont}" > /dev/null
                curl -z "$HOME/mp4/${cont}" -o "$HOME/mp4/${cont}" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000026/${cont}"
            fi

            echo
            echo "File complete, continuing to next item."
            echo

        done
        rm ${GRAB_FILE}

        $HOME/tmpdir_maintenance/mod_Twitter/./tcli.sh -c statuses_update -s "automagic #IHDNpi_26 channel updated." &

    fi

# possible method for creating new playlist
# find "$(pwd)/aud" -maxdepth 1 -type f

#         wget -r -nd -nc -l 2 -w 3 -A mp4 -P $HOME/mp4 http://192.168.200.6/files/

#         wget -r -nd -nc -l 2 -w 3 -A mp3 -P $HOME/aud http://192.168.200.6/files/


    echo "Done syncing." >> log.txt
    echo "Removing running token."  >> log.txt
    echo $(date +"%T") >> log.txt
    rm "${HOME}/syncing"

# Else do nothing files
#    else
#        echo "Already syncing!"
fi


rm .getchan26

# tput clear
exit 0
