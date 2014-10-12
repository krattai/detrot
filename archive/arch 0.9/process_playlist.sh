#!/bin/bash
#
# Plays videos from playlist
#
# Copyright Â© 2013 Janne Enberg http://lietu.net/
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
#
# May 14, 2014 Larry added GPIO 23 to switch on video
#
# Set up GPIO 23 and set to output 1
#
# Eventually, it would be nice to have this script create
# log or file to indicate that it completed successfully
# this would be the last command before a the script exits
# on a success rather than a fail exit

sudo bash /home/pi/scripts/led_on.sh

# If you want to switch omxplayer to something else, or add parameters, use these
PLAYER="omxplayer"
PLAYER_OPTIONS=""

# Where is the playlist
PLAYLIST_FILE="${HOME}/.playlist"

touch .omx_playing

# Process playlist contents
while [ -f ".omx_playing" ]; do
        # Sleep a bit so it's possible to kill this
        # sleep 1

        # Do nothing if the playlist doesn't exist
        if [ ! -f "${PLAYLIST_FILE}" ]; then
                echo "Playlist file ${PLAYLIST_FILE} not found"
                continue
        fi

        # Get the top of the playlist
        file=$(cat "${PLAYLIST_FILE}" | head -n1)

        # And strip it off the playlist file
        cat "${PLAYLIST_FILE}" | tail -n+2 > "${PLAYLIST_FILE}.new"
        mv "${PLAYLIST_FILE}.new" "${PLAYLIST_FILE}"

        # Skip if this is empty
        if [ -z "${file}" ]; then
                echo "Playlist empty or bumped into an empty entry for some reason"

                # added by Kevin: exit clean if empty
                rm .omx_playing

                continue

        fi

        # Check that the file exists
        if [ ! -f "${file}" ]; then
                echo "Playlist entry ${file} not found"
                continue
        fi

        clear
        echo
        echo "Playing ${file} ..."
        echo

#         cat ${file}

        "${PLAYER}" ${PLAYER_OPTIONS} "${file}" > /dev/null

        echo
        echo "Playback complete, continuing to next item on playlist."
        echo
done

if [ -f ".omx_playing" ]; then
    rm .omx_playing
fi

exit
