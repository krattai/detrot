#!/usr/bin/env bash
#
# grabs and makes playlist
#
# Copyright (C) 2014 IHDN, Uvea I. S., Kevin Rattai
#
# name of file ihdn_det_mon.sh
# create file and / or place file in scripts folder
#
# Make sure file is executable:
# chmod 777 $HOME/scripts/ihdn_det_mon.sh
#
# Run file by typing command:
# $HOME/scripts/./ihdn_det_mon.sh &
#
# Stop program by typing the following:
# rm .monitoring
#
# Place only one *.mp4 file in pl folder to ensure only one video play

cd $HOME
touch .monitoring
while [ -f "${HOME}/.monitoring" ]; do
    rm .playlist
    if [ ! -f "${HOME}/.playlist" ]; then
        $HOME/scripts/./playlist.sh ~/pl/*.mp4
    fi
    touch .ready
    while [ ! -f "${HOME}/.play" ]; do
        echo "Waiting for .play request" >> /dev/null
    done
    touch .playing
    rm .play
    $HOME/scripts/./process_playlist.sh
    touch .videoend
    rm .playing
    while [ ! -f "${HOME}/.resetvideo" ]; do
        echo "Waiting for .resetvideo" >> /dev/null
    done
    rm .resetvideo
done

exit
