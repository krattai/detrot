#!/bin/bash
# runs updates
#
# Copyright (C) 2014 IHDN, Uvea I. S., Kevin Rattai
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

# this was used to set keyboard LED for detector hardware to know
# not to process

# xset led 3

# set to home directory

cd $HOME

# makes pl (for playlist) directory if not exist

# mkdir -p pl

# copies files to directory if not exist

# cp -n mp4/ihdn* pl

# if desired, remove old ad files from unit

# cd ~/mp4

# rm *

# add extra content to pl directory if desired / necessary

# cp -n mp4/ad000.mp4 pl
# cp -n mp4/ad002.mp4 pl

# remove content from pl directory if desired / necessary

# rm ~/pl/ad000.mp4
# rm ~/pl/ad002.mp4

# set working directory as base of pi users

# cd $HOME

# sleep 1

# The original playlist.sh and process_playlist.sh scripts were not
# on the device while there were already ads on the device, so used
# this script instead of the grabfiles.sh script to get and ultimately
# execute these files on initial change over from old method
#
# Leaving for now as REM to show as example

# wget -N -nd http://192.168.200.6/files/process_playlist.sh -O $HOME/scripts/process_playlist.sh

# wget grabfiles.sh, set to executible, and run

# wget -N -nd http://ihdn.ca/ftp/grabfiles.sh -O $HOME/grabfiles.sh

# check network
# wget -q --tries=5 --timeout=20 http://google.com
wget -q --tries=5 --timeout=20 http://192.168.200.6
if [[ $? -eq 0 ]]; then
        rm index*
#        echo "Online"

#        wget -N -nd http://192.168.200.20/files/getupdt.sh -O $HOME/scripts/getupdt.sh

#        chmod 777 scripts/getupdt.sh

# wget -r -nd -Nc -l2 -w 3 -A.mp4 -P $HOME/mp4 http://192.168.200.6/files/

# wget -r -nd -Nc -l2 -w 3 -i file -P $HOME/mp4 http://192.168.200.6/files/

# wget -c -r -nd -nc -l2 -w 3 --limit-rate=50k http://192.168.200.6/files/AEBL_00.png

        wget -t 1 -N -nd http://192.168.200.6/files/grabfiles.sh -O $HOME/scripts/grabfiles.sh

        chmod 777 scripts/grabfiles.sh
else
    wget -q --tries=5 --timeout=20 http://google.com
    if [[ $? -eq 0 ]]; then
        wget -t 1 -N -nd "https://www.dropbox.com/s/c2j6ygj5957wrdh/grabfiles.sh" -O $HOME/scripts/grabfiles.sh

        chmod 777 scripts/grabfiles.sh
    else
        echo "Offline"
    fi
fi

scripts/./grabfiles.sh

# scripts/./cronadd.sh

# script was from original XPO boxes which ran totem
# leaving the following as an example

# totem --quit &

# wait

# wget -N -nd http://ihdn.ca/ftp/ihdn.ca.2.9.pls -O $HOME/demo/ihdn.ca.2.9.pls &

# wait

# used to turn of LED so detector hardware knew to resume processing

# xset -led 3

# sleep 1

# The following was used originally in testing as a way to play
# a number of files with omxplayer.  Have since begun using the
# process_playlist.sh script.  Leaving this as example.

# clear && omxplayer mp4/ihdntest00.mp4 > /dev/null && omxplayer mp4/ihdntest01.mp4 > /dev/null && omxplayer mp4/ihdntest02.mp4 > /dev/null

# create (or appends if not empty) playlist from directory

# mkdir aud

# wget -N -nd http://192.168.200.6/files/90.mp3 -O $HOME/aud/90.mp3

scripts/./playlist.sh ~/pl/*.mp4

scripts/./playlist.sh ~/aud/*.mp3

# play through the playlist

scripts/./process_playlist.sh

# totem --fullscreen $HOME/demo/ihdn.ca.2.9.pls

# starts next round of updates

exec scripts/./getupdt.sh &

# apt-get update

# turn on CAPS and wait 5 minutes

# reboot system
