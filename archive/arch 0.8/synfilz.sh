#!/usr/bin/env bash
#
# sync files
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
#
# wget -r -nd -Nc -l2 -w 3 -i file -P $HOME/mp4 http://192.168.200.6/files/
#
# or
#
# wget -r -nd -Nc -l2 -w 3 -A.mp4 -P $HOME/mp4 http://192.168.200.6/files/
#
# or
#
# wget -b -c -q -r -nd -nc -l2 -w3 --limit-rate=50k -A.mp4 -P $HOME/mp4 http://192.168.200.6/files/
#
# -b background
# -c continue if prior broken; not working in some cases do not use
# -q quiet no output log
# -r recursive required if multiple
# -nd no direcotry so not putting paths
# -nc no clobber so not download if exist
# -l2 only 2 levels, important with http as level 2 is files
# -w3 wait 3 seconds so as not to overwhelm server with requests
# --limit-rate to save bandwidth on both client and server
# -A is files of type
# -P sends to path on client
#
# When running Wget with ‘-N’, with or without ‘-r’ or ‘-p’, the
# decision as to whether or not to download a newer copy of a file
# depends on the local and remote timestamp and size of the file (see
# Time-Stamping). ‘-nc’ may not be specified at the same time as ‘-N’. 
#
# Eventually, it would be nice to have this script create
# log or file to indicate that it completed successfully
# this would be the last command before a the script exits
# on a success rather than a fail exit

#Check network before syncing
wget -q --tries=5 --timeout=20 http://192.168.200.6
if [[ $? -eq 0 ]]; then
    rm index*
    echo "Online"

    # Check if not syncing
    # should append syncing to syncing file and dump it to dropbox

    if [ ! -f "${HOME}/syncing" ]; then
        echo "Currently not syncing."
        echo "Making running token."
        touch syncing

        wget -r -nd -nc -l 2 -w 3 -A mp4 -P $HOME/mp4 http://192.168.200.6/files/

        wget -r -nd -nc -l 2 -w 3 -A mp3 -P $HOME/aud http://192.168.200.6/files/


        echo "Done syncing."
        echo "Removing running token."
        rm syncing

    # Else do nothing files
    #    else
    #        echo "Already syncing!"
    fi



# If you want to switch omxplayer to something else, or add parameters, use these
# PLAYER="omxplayer"
# PLAYER_OPTIONS=""

# File to process
# PROC_FILE="${HOME}/.playlist"

# Process file contents
# while [ true ]; do
        # Sleep so it's possible to kill this
#         sleep 1

        # check file doesn't exist
#         if [ ! -f "${PROC_FILE}" ]; then
#                 echo "Playlist file ${PROC_FILE} not found"
#                 continue
#         fi

        # Get the top of the playlist
#         cont=$(cat "${PROC_FILE}" | head -n1)

        # And strip it off the playlist file
#         cat "${PROC_FILE}" | tail -n+2 > "${PROC_FILE}.new"
#         mv "${PROC_FILE}.new" "${PROC_FILE}"

        # Skip if this is empty
#         if [ -z "${cont}" ]; then
#                 echo "Playlist empty or bumped into an empty entry for some reason"

                # added by Kevin: exit clean if empty
#                 exit 1

#                 continue

#         fi

        # Check that the file exists
#         if [ ! -f "${cont}" ]; then
#                 echo "Playlist entry ${cont} not found"
#                 continue
#         fi

#         clear
#         echo
#         echo "Playing ${cont} ..."
#         echo

#         "${PLAYER}" ${PLAYER_OPTIONS} "${cont}" > /dev/null

#         echo
#         echo "Playback complete, continuing to next item on playlist."
#         echo

# while complete
# done

else
        echo "Offline"
fi

# tput clear
exit 0
