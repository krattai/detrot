#!/bin/bash
# Creates an AEBL system from base raspbian image
# user should be Pi, password can be anything
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
#
# Useage:
# wget -N -r -nd -l2 -w 3 -P $HOME --limit-rate=50k http://192.168.200.6/files/create-asys.sh; chmod 777 $HOME/create-asys.sh; $HOME/./create-asys.sh; rm $HOME/create-asys.sh
# or
# wget -N -r -nd -l2 -w 3 -P $HOME --limit-rate=50k "https://www.dropbox.com/s/1t3ejk4iyzm07u6/create-asys.sh"; chmod 777 $HOME/create-asys.sh; $HOME/./create-asys.sh; rm $HOME/create-asys.sh


LOCAL_SYS="/home/pi/.local"
NETWORK_SYS="/home/pi/.network"
OFFLINE_SYS="/home/pi/.offline"
AEBL_SYS="/home/pi/.aeblsys"

TEMP_DIR="/home/pi/tempdir"
MP3_DIR="/home/pi/mp3"
MP4_DIR="/home/pi/mp4"
PL_DIR="/home/pi/pl"
CTRL_DIR="/home/pi/ctrl"
BIN_DIR="/home/pi/bin"

USER=`whoami`
CRONLOC=/var/spool/cron/crontabs
# CRONCOMMFILE=/tmp/cron_comm_file.sh
CRONCOMMFILE="${HOME}/testcron.sh"
CRONGREP=$(crontab -l | cat )

IPe0=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f 1)
MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')

cd $HOME

# Discover network availability
#

ping -c 1 8.8.8.8

if [ $? -eq 0 ]; then
    touch .network
    echo "Internet available."
else
    rm .network
fi

ping -c 1 192.168.200.6

if [[ $? -eq 0 ]]; then
    touch .local
    echo "Local network available."
else
    rm .local
fi

if [ ! -f "${LOCAL_SYS}" ] && [ ! -f "${NETWORK_SYS}" ]; then
    touch .offline
    echo "No network available."
else
    rm .offline
fi

touch ${AEBL_SYS}

export PATH=$PATH:${BIN_DIR}:$HOME/scripts

# Get necessary asys files
#

if [ ! -f "${OFFLINE_SYS}" ]; then

    if [ -f "${LOCAL_SYS}" ]; then

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/asys.zip

    else

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k "https://www.dropbox.com/s/kejuyn1m40eitph/asys.zip"

    fi

    cd ${TEMP_DIR}

    unzip asys.zip

    rm asys.zip

    cd $HOME

    sudo rm /etc/init.d/bootup.sh
    sudo mv ${TEMP_DIR}/bootup.sh /etc/init.d
    sudo chmod 755 /etc/init.d/bootup.sh
    sudo update-rc.d bootup.sh defaults

    cat ${TEMP_DIR}/aeblcron.tab > $CRONCOMMFILE

    crontab "${CRONCOMMFILE}"
    rm $CRONCOMMFILE
    rm ${TEMP_DIR}/aeblcron.tab

    sudo rm /etc/samba/smb.conf

    sudo mv ${TEMP_DIR}/smb.conf /etc/samba

    sudo mv ${TEMP_DIR}/samba.service  /etc/avahi/services/

    mv ${TEMP_DIR}/macip.sh $HOME/scripts

    chmod 777 scripts/macip.sh

    mv ${TEMP_DIR}/mkuniq.sh $HOME/scripts

    chmod 777 scripts/mkuniq.sh

    mv ${TEMP_DIR}/getupdt.sh $HOME/scripts

    chmod 777 scripts/getupdt.sh

    mv "${TEMP_DIR}/ihdn mrkt 14051500.mp4" ${PL_DIR}

    cp "${PL_DIR}/ihdn mrkt 14051500.mp4" ${MP4_DIR}

    mv ${TEMP_DIR}/inetup.sh $HOME/scripts

    chmod 777 scripts/inetup.sh

    mv ${TEMP_DIR}/l-ctrl.sh $HOME/scripts

    chmod 777 scripts/l-ctrl.sh

    mv ${TEMP_DIR}/grabfiles.sh $HOME/scripts

    chmod 777 scripts/grabfiles.sh

    mv ${TEMP_DIR}/aebl_play.sh $HOME/scripts

    chmod 777 scripts/aebl_play.sh

    mv ${TEMP_DIR}/mkplay.sh $HOME/scripts

    chmod 777 scripts/mkplay.sh

    mv ${TEMP_DIR}/playlist.sh $HOME/scripts

    chmod 777 scripts/playlist.sh

    mv ${TEMP_DIR}/process_playlist.sh $HOME/scripts

    chmod 777 scripts/process_playlist.sh

    mv ${TEMP_DIR}/dropbox_uploader.sh $HOME/scripts

    chmod 777 scripts/dropbox_uploader.sh

    mv ${TEMP_DIR}/dropbox_uploader.conf $HOME/.dropbox_uploader

    $HOME/tmpdir_maintenance/mod_Twitter/./tcli.sh -c statuses_update -s "automagic @kratt, #AEBLpi ${MACe0} registered." &

    # sleep 5 seconds to ensure system ready for reboot
    echo "Processing files.  Please wait."
    sleep 5

    rm ${TEMP_DIR}/*

    rmdir ${TEMP_DIR}

fi

rm $HOME/scripts/create-asys.sh

sudo reboot

exit
