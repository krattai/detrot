#!/usr/bin/env bash
#
# processes text file line by line
# was - Plays videos from playlist
#
# Original code Janne Enberg http://lietu.net/
# under wtfpl v.2 see http://www.wtfpl.net/ for more details.
#
# Therefore:
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
#
# Eventually, it would be nice to have this script create
# log or file to indicate that it completed successfully
# this would be the last command before a the script exits
# on a success rather than a fail exit

# If you want to switch omxplayer to something else, or add parameters, use these
PLAYER="omxplayer"
PLAYER_OPTIONS=""

# File to process
PROC_FILE="${HOME}/.playlist"

# Process file contents
while [ true ]; do
        # Sleep so it's possible to kill this
        sleep 1

        # check file doesn't exist
        if [ ! -f "${PROC_FILE}" ]; then
                echo "Playlist file ${PROC_FILE} not found"
                continue
        fi

        # Get the top of the playlist
        cont=$(cat "${PROC_FILE}" | head -n1)

        # And strip it off the playlist file
        cat "${PROC_FILE}" | tail -n+2 > "${PROC_FILE}.new"
        mv "${PROC_FILE}.new" "${PROC_FILE}"

        # Skip if this is empty
        if [ -z "${cont}" ]; then
                echo "Playlist empty or bumped into an empty entry for some reason"

                # added by Kevin: exit clean if empty
                exit 1

                continue

        fi

        # Check that the file exists
        if [ ! -f "${cont}" ]; then
                echo "Playlist entry ${cont} not found"
                continue
        fi

        clear
        echo
        echo "Playing ${cont} ..."
        echo

        "${PLAYER}" ${PLAYER_OPTIONS} "${cont}" > /dev/null

        echo
        echo "Playback complete, continuing to next item on playlist."
        echo
done

