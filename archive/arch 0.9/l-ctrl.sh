#!/bin/bash
# gets update scripts
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
#
# This eventually is the control script.  It will be a cron job
# that will check with Master Control and grab the control file.
# The control file will contain all the relevant information that
# will allow the box to manage its local operations.

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
MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')


cd $HOME

echo "Running scheduled l-ctrl job" >> log.txt
echo $(date +"%T") >> log.txt

killall dbus-daemon

if [ ! -f "${OFFLINE_SYS}" ]; then
    if [ -f "${LOCAL_SYS}" ]; then
        echo "Getting files from scheduled l-ctrl job." >> log.txt
        echo $(date +"%T") >> log.txt

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/l-ctrl.sh

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/synfilz.sh

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/mkplay.sh

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/aebl_play.sh

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/ihdn_play.sh

        if [ -f "${AEBL_TEST}" ]; then
            wget -N -r -nd -l2 -w 3 -O "$HOME/mynew.pl" --limit-rate=50k http://192.168.200.6/files/aebltest.pl
        fi

        if [ -f "${AEBL_SYS}" ]; then
            wget -N -r -nd -l2 -w 3 -O "$HOME/mynew.pl" --limit-rate=50k http://192.168.200.6/files/aebltest.pl
        fi

        if [ -f "${IHDN_TEST}" ]; then
            wget -N -r -nd -l2 -w 3 -O "$HOME/mynew.pl" --limit-rate=50k http://192.168.200.6/files/ihdntest.pl
        fi

        if [ -f "${HOME}/.ihdnfol-1" ]; then
            wget -N -r -nd -l2 -w 3 -o "$HOME/mynew.pl" --limit-rate=50k http://192.168.200.6/files/ihdntest.pl
        fi


    else
        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/k1ifbgmvhjh83na/l-ctrl.sh"

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/slt6ef1h54k68w4/synfilz.sh"

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/m4fe1tu5luvvzni/mkplay.sh"

        if [ -f "${HOME}/.ihdnfol26" ]; then
            curl -o "$HOME/mynew.pl" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000026/chan26.pl"
        fi

        if [ -f "${HOME}/.ihdnfol27" ]; then
            curl -o "$HOME/mynew.pl" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000027/chan27.pl"
        fi

    fi

    chmod 777 scripts/l-ctrl.sh
    chmod 777 scripts/synfilz.sh
    chmod 777 scripts/mkplay.sh

    scripts/./synfilz.sh &

fi

exit
