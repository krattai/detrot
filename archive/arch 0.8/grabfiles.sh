#!/bin/bash
# Shell script to grab video files off server
#
# Copyright (C) 2014 IHDN, Uvea I. S., Kevin Rattai
#
# This file will likely be superceded by the synfilz.sh script
# as playable content file management.  This script may become
# depricated, although may continue to server future value as
# a method of managing non-playable content on the device.
#
# Get files
#
# as example from old ihdn.ca ftp server
# -N timestamp apparently has problem iwht -O parameter
# so use -nc parameter in place of -N
#
# Eventually, it would be nice to have this script create
# log or file to indicate that it completed successfully
# this would be the last command before a the script exits
# on a success rather than a fail exit

# NB: this should be link to krattai dropbox public folder (not used):
# https://www.dropbox.com/sh/37ntnxfrwz637bk/AAB1CaxMLmNr6l-VwOCcSHUna


 
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_01_1.VOB -O $HOME/demo/VTS_01_1.VOB

# get files from SOHO test server if not exist

# check network
# wget -q --tries=5 --timeout=20 http://google.com
wget -q --tries=5 --timeout=20 http://192.168.200.6
if [[ $? -eq 0 ]]; then
        rm index*
        echo "Online"

        wget -r -nd -nc -l 2 -w 3 -A mp4 -P $HOME/mp4 http://192.168.200.6/files/

# wget -r -nd -Nc -l2 -w 3 -A.mp4 -P $HOME/mp4 http://192.168.200.6/files/

# wget -r -nd -Nc -l2 -w 3 -i file -P $HOME/mp4 http://192.168.200.6/files/

# wget -c -r -nd -nc -l2 -w 3 --limit-rate=50k http://192.168.200.6/files/AEBL_00.png

#        rm scripts/synfilz.sh

# When running Wget with ‘-N’, with or without ‘-r’ or ‘-p’, the
# decision as to whether or not to download a newer copy of a file
# depends on the local and remote timestamp and size of the file (see
# Time-Stamping). ‘-nc’ may not be specified at the same time as ‘-N’. 

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/getupdt.sh

        chmod 777 scripts/getupdt.sh

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/synfilz.sh

        chmod 777 scripts/synfilz.sh

#        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/bootup.sh

#        sudo rm /etc/init.d/bootup.sh
#        sudo mv /home/pi/scripts/bootup.sh /etc/init.d
#        sudo chmod 755 /etc/init.d/bootup.sh
#        sudo update-rc.d bootup.sh defaults


#         rm scripts/l-ctrl.sh

#         wget -r -nd -nc -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/l-ctrl.sh

#         chmod 777 scripts/l-ctrl.sh


# wget -nc -nd http://192.168.200.12/files/l-ctrl.sh -O $HOME/scripts/l-ctrl.sh

# chmod 777 scripts/l-ctrl.sh

# wget -nc -nd http://192.168.200.12/files/lctrl.ctab -O $HOME/scripts/lctrl.ctab


    wget -nc -nd http://192.168.200.6/files/ad000.mp4 -O $HOME/mp4/ad000.mp4

# get some extra files to mix things up if not exist

# wget -nc -nd http://192.168.200.6/files/ihdntest00.mp4 -O $HOME/mp4/ihdntest00.mp4

# wget -nc -nd http://192.168.200.6/files/90.mp3 -O $HOME/aud/90.mp3

# wget -nc -nd "http://192.168.200.6/files/Arcade Hero (2010).mp3" -O "$HOME/aud/Arcade Hero (2010).mp3"

# wget -nc -nd http://192.168.200.6/files/inetup.sh -O $HOME/scripts/inetup.sh

# chmod 777 scripts/inetup.sh

# rm scripts/cronadd.sh

    wget -nc -nd http://192.168.200.6/files/cronadd.sh -O $HOME/scripts/cronadd.sh

# chmod 777 scripts/cronadd.sh

# wget -nc -nd http://192.168.200.6/files/chckint.ctab -O $HOME/scripts/chckint.ctab

# wget -nc -nd http://192.168.200.6/files/a90.mp3 -O $HOME/aud/a90.mp3

# wget -nc -nd "http://192.168.200.6/files/Ask A Ninja - Question 16 How To Kill A Ninja.mp4" -O "$HOME/mp4/Ask A Ninja - Question 16 How To Kill A Ninja.mp4"

# wget -nc -nd "http://192.168.200.6/files/Eben Moglen - From the birth of printing to industrial culture the root of copyright.mp4" -O "$HOME/mp4/Eben Moglen - From the birth of printing to industrial culture the root of copyright.mp4"

# wget -nc -nd "http://192.168.200.6/files/ad018.mp4" -O "$HOME/mp4/ad018.mp4"

# cp -n mp4/* pl

# grab playlist.sh and process_playlist.sh scripts
# although -N is used, it still forces an overwrite
# because apparently timestamp -N doesn't work with -O
#
# so
#
# this probably doesn't need to be done every time, but leaving here
# for now
#
# also need to chmod them to executible so doing so, just in case
# execute flag is lost

# wget -N -nd http://192.168.200.6/files/playlist.sh -O $HOME/scripts/playlist.sh

# chmod 777 scripts/playlist.sh

# wget -N -nd http://192.168.200.6/files/process_playlist.sh -O $HOME/scripts/process_playlist.sh

# chmod 777 scripts/process_playlist.sh

else
    wget -q --tries=5 --timeout=20 http://google.com
    if [[ $? -eq 0 ]]; then

        rm .id

        wget -t 1 -N -nd "https://www.dropbox.com/s/7e2png1lmzzmzxh/getupdt.sh" -O $HOME/scripts/getupdt.sh

        chmod 777 scripts/getupdt.sh

        wget -t 1 -N -nd "https://www.dropbox.com/sh/9lxzyf9i75ogh58/AAC2xNOFOSojc14brCziBPgua/mkuniq.sh" -O $HOME/mkuniq.sh

        chmod 777 mkuniq.sh

        wget -t 1 -N -nd "https://www.dropbox.com/s/hjmrvwqmzefhnhy/macip.sh" -O $HOME/macip.sh

        chmod 777 macip.sh
    fi
fi

# tput clear
exit 0
