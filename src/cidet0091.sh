#!/bin/bash
# Creates an AEBL system from base raspbian image
# user should be Pi, password can be anything
#
# Copyright (C) 2014 IHDN, Uvea I. S., Kevin Rattai
#
# Useage:
# wget -N -r -nd -l2 -w 3 -P $HOME --limit-rate=50k http://192.168.200.6/files/create-idet.sh; chmod 777 $HOME/create-idet.sh; $HOME/./create-idet.sh; rm $HOME/create-idet.sh
# or
# wget -N -r -nd -l2 -w 3 -P $HOME --limit-rate=50k "https://www.dropbox.com/s/kkb5wq8p7wjgtfw/create-idet.sh"; chmod 777 $HOME/create-idet.sh; $HOME/./create-idet.sh; rm $HOME/create-idet.sh

LOCAL_SYS="/home/pi/.local"
NETWORK_SYS="/home/pi/.network"
OFFLINE_SYS="/home/pi/.offline"
IHDN_SYS="/home/pi/.ihdnsys"
IHDN_DET="/home/pi/.ihdndet"

TEMP_DIR="/home/pi/tempdir"
MP3_DIR="/home/pi/mp3"
MP4_DIR="/home/pi/mp4"
PL_DIR="/home/pi/pl"
CTRL_DIR="/home/pi/ctrl"
BIN_DIR="/home/pi/bin"
SCRPT_DIR="/home/pi/.scripts"
BKUP_DIR="/home/pi/.backup"

USER=`whoami`
CRONLOC=/var/spool/cron/crontabs
# CRONCOMMFILE=/tmp/cron_comm_file.sh
CRONCOMMFILE="${HOME}/testcron.sh"
CRONGREP=$(crontab -l | cat )

IPe0=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f 1)
MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')

cd $HOME

rm .scripts
mkdir ${SCRPT_DIR}

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

touch ${IHDN_SYS}
touch ${IHDN_DET}

export PATH=$PATH:${BIN_DIR}:$HOME/scripts

# Get necessary idet files
#

if [ ! -f "${OFFLINE_SYS}" ]; then

    if [ -f "${LOCAL_SYS}" ]; then

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/irot0091.zip

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/idet0091.zip

        sudo wget -N -nd -w 3 -P /boot --limit-rate=50k http://192.168.200.6/files/dt-blob.bin

    else

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k "https://www.dropbox.com/s/dnny8a415m2iwbj/idet0091.zip"

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k "https://www.dropbox.com/s/um8k7g32ese8wn2/irot0091.zip"

        wget -N -nd -w 3 -P /boot --limit-rate=50k "https://www.dropbox.com/s/n119zo21ax6ew2n/dt-blob.bin"

    fi

    cd ${TEMP_DIR}

    unzip -o irot0091.zip

    rm irot0091.zip

    cd $HOME

    cat ${TEMP_DIR}/aeblcron.tab > $CRONCOMMFILE
    crontab "${CRONCOMMFILE}"
    rm $CRONCOMMFILE
    rm ${TEMP_DIR}/aeblcron.tab

    sudo rm /etc/samba/smb.conf
    sudo mv ${TEMP_DIR}/rsmb.conf /etc/samba/smb.conf
    sudo mv ${TEMP_DIR}/samba.service  /etc/avahi/services/

    mv ${TEMP_DIR}/ctrlwtch.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/ctrlwtch.sh

    mv ${TEMP_DIR}/macip.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/macip.sh

    mv ${TEMP_DIR}/mkuniq.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/mkuniq.sh

    mv ${TEMP_DIR}/startup.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/startup.sh

    mv ${TEMP_DIR}/run.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/run.sh

    mv "${TEMP_DIR}/ihdn mrkt 14051500.mp4" ${PL_DIR}
    cp "${PL_DIR}/ihdn mrkt 14051500.mp4" ${MP4_DIR}

    mv ${TEMP_DIR}/inetup.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/inetup.sh

    mv ${TEMP_DIR}/l-ctrl.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/l-ctrl.sh

    mv ${TEMP_DIR}/synfilz.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/synfilz.sh

    mv ${TEMP_DIR}/grabfiles.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/grabfiles.sh

    mv ${TEMP_DIR}/ihdn_play.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/ihdn_play.sh

    mv ${TEMP_DIR}/ihdn_tests.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/ihdn_tests.sh

    mv ${TEMP_DIR}/mkplay.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/mkplay.sh

    mv ${TEMP_DIR}/playlist.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/playlist.sh

    mv ${TEMP_DIR}/process_playlist.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/process_playlist.sh

    mv ${TEMP_DIR}/dropbox_uploader.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/dropbox_uploader.sh
    mv ${TEMP_DIR}/dropbox_uploader.conf $HOME/.dropbox_uploader

    mv ${TEMP_DIR}/patch.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/patch.sh

    mv ${TEMP_DIR}/upgrade.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/upgrade.sh

    mv ${TEMP_DIR}/admin_guide.txt /home/pi/ctrl
    cp /home/pi/ctrl/admin_guide.txt /home/pi/.backup
    mv ${TEMP_DIR}/ihdnWelcome.txt /home/pi/ctrl/Welcome.txt
    cp /home/pi/ctrl/Welcome.txt /home/pi/.backup

    mv ${TEMP_DIR}/grbchan.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/grbchan.sh
    mv ${TEMP_DIR}/grbchan0.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/grbchan0.sh
    mv ${TEMP_DIR}/grbchan25.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/grbchan25.sh
    mv ${TEMP_DIR}/grbchan26.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/grbchan26.sh
    mv ${TEMP_DIR}/grbchan27.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/grbchan27.sh

    # archive files
    mkdir ${BKUP_DIR}
    cp $HOME/version ${BKUP_DIR}
    mkdir ${BKUP_DIR}/scripts
    cp ${SCRPT_DIR}/*.sh ${BKUP_DIR}/scripts
    mkdir ${BKUP_DIR}/bin
    cp ${BIN_DIR}/* ${BKUP_DIR}/bin
    mkdir ${BKUP_DIR}/pl
    cp $HOME/pl/* ${BKUP_DIR}/pl
    mkdir ${BKUP_DIR}/ctrl
    cp $HOME/ctrl/* ${BKUP_DIR}/ctrl

    cp -p ${SCRPT_DIR}/* /run/shm/scripts

# ~~~~~~~~~~~~~~

    cd ${TEMP_DIR}

    unzip -o idet0091.zip

    rm idet0091.zip

    cd $HOME

    # update rpi-update to do firmware revert
    sudo apt-get install rpi-update
    # not on Pi2
    if [[ `cat /proc/cpuinfo | grep 000e` ]]; then
        # from https://github.com/raspberrypi/firmware/issues/321
        # revert firmware to Jul5th, 2014 to fix undesirable GPIO2 behaviour
        # to remove old version, use:
        # sudo rm /boot/.firmware_revision
        sudo rm /boot/.firmware_revision
        sudo rpi-update d9eb023ba98317d81fc53a3f9d6752b127a8dbbf
    fi

    cat ${TEMP_DIR}/aeblcron.tab > $CRONCOMMFILE

    mv ${TEMP_DIR}/det.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/det.sh
    cp ${SCRPT_DIR}/det.sh /home/pi/bin

    mv ${TEMP_DIR}/ctrlwtch.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/ctrlwtch.sh

    mv ${TEMP_DIR}/macip.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/macip.sh

    mv ${TEMP_DIR}/mkuniq.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/mkuniq.sh

    mv ${TEMP_DIR}/startup.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/startup.sh

    mv ${TEMP_DIR}/run.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/run.sh

    mkdir /home/pi/ad
    mv "${TEMP_DIR}/IHDN Advertise Here.mp4" ${PL_DIR}
    cp "${PL_DIR}/IHDN Advertise Here.mp4" ${MP4_DIR}
    cp "${PL_DIR}/IHDN Advertise Here.mp4" /home/pi/ad

    mv ${TEMP_DIR}/inetup.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/inetup.sh

    mv ${TEMP_DIR}/l-ctrl.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/l-ctrl.sh

    mv ${TEMP_DIR}/synfilz.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/synfilz.sh

    mv ${TEMP_DIR}/grabfiles.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/grabfiles.sh

    mv ${TEMP_DIR}/ihdn_play.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/ihdn_play.sh

    mv ${TEMP_DIR}/ihdn_tests.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/ihdn_tests.sh

    mv ${TEMP_DIR}/mkplay.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/mkplay.sh

    mv ${TEMP_DIR}/playlist.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/playlist.sh

    mv ${TEMP_DIR}/process_playlist.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/process_playlist.sh

    mv ${TEMP_DIR}/dropbox_uploader.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/dropbox_uploader.sh
    mv ${TEMP_DIR}/dropbox_uploader.conf $HOME/.dropbox_uploader

    mv ${TEMP_DIR}/patch.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/patch.sh

    mv ${TEMP_DIR}/upgrade.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/upgrade.sh

    mv ${TEMP_DIR}/admin_guide.txt /home/pi/ctrl
    cp /home/pi/ctrl/admin_guide.txt /home/pi/.backup
    mv ${TEMP_DIR}/ihdnWelcome.txt /home/pi/ctrl/Welcome.txt
    cp /home/pi/ctrl/Welcome.txt /home/pi/.backup

    mv ${TEMP_DIR}/grbchan.sh ${SCRPT_DIR}
    chmod 777 ${SCRPT_DIR}/grbchan.sh

    # archive files
    mkdir ${BKUP_DIR}
    cp $HOME/version ${BKUP_DIR}
    mkdir ${BKUP_DIR}/scripts
    cp ${SCRPT_DIR}/*.sh ${BKUP_DIR}/scripts
    mkdir ${BKUP_DIR}/bin
    cp ${BIN_DIR}/* ${BKUP_DIR}/bin
    mkdir ${BKUP_DIR}/pl
    cp $HOME/pl/* ${BKUP_DIR}/pl
    mkdir ${BKUP_DIR}/ctrl
    cp $HOME/ctrl/* ${BKUP_DIR}/ctrl

    # set bootup last in case of fail during install
    sudo rm /etc/init.d/bootup.sh
    sudo mv ${TEMP_DIR}/ihdn_det_bootup.sh /etc/init.d/bootup.sh
    sudo chmod 755 /etc/init.d/bootup.sh
    sudo update-rc.d bootup.sh defaults

    cp -p ${SCRPT_DIR}/* /run/shm/scripts


    $HOME/tmpdir_maintenance/mod_Twitter/./tcli.sh -c statuses_update -s "automagic @kratt, #IHDNdet ${MACe0} registered." &

    # sleep 5 seconds to ensure system ready for reboot
    echo "Processing files.  Please wait."
    sleep 5

    rm ${TEMP_DIR}/*

    rmdir ${TEMP_DIR}

fi

rm $HOME/scripts/create-idet.sh

sudo reboot

exit
