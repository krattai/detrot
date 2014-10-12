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
AUD_DIR="/home/pi/aud"
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

mkdir ${TEMP_DIR}
mkdir ${MP3_DIR}
mkdir ${MP4_DIR}
mkdir ${PL_DIR}
mkdir ${AUD_DIR}
mkdir ${CTRL_DIR}
mkdir ${BIN_DIR}

chmod 777 ${MP3_DIR}
chmod 777 ${MP4_DIR}
chmod 777 ${PL_DIR}
chmod 777 ${AUD_DIR}
chmod 777 ${CTRL_DIR}

touch ${IHDN_SYS}
touch ${IHDN_DET}

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

# Get necessary IHDN files
#

if [ ! -f "${OFFLINE_SYS}" ]; then

    sudo apt-get update

    sudo apt-get -y install fbi samba samba-common-bin

    sudo rpi-update

    if [ -f "${LOCAL_SYS}" ]; then

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/AEBL_00.png

        sudo mv ${TEMP_DIR}/AEBL_00.png /etc

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/asplash.sh

        sudo mv ${TEMP_DIR}/asplash.sh /etc/init.d

        sudo chmod a+x /etc/init.d/asplash.sh

        sudo insserv /etc/init.d/asplash.sh

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/ihdn_det_bootup.sh

        cp ${TEMP_DIR}/ihdn_det_bootup.sh ${TEMP_DIR}/bootup.sh
        rm ${TEMP_DIR}/ihdn_det_bootup.sh

        sudo rm /etc/init.d/bootup.sh
        sudo mv ${TEMP_DIR}/bootup.sh /etc/init.d
        sudo chmod 755 /etc/init.d/bootup.sh
        sudo update-rc.d bootup.sh defaults

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/aeblcron.tab

        cat ${TEMP_DIR}/aeblcron.tab > $CRONCOMMFILE

        crontab "${CRONCOMMFILE}"
        rm $CRONCOMMFILE
        rm ${TEMP_DIR}/aeblcron.tab

        wget -N -nd -w 3 -P $HOME --limit-rate=50k http://192.168.200.6/files/smb.conf

        sudo rm /etc/samba/smb.conf

        sudo mv $HOME/smb.conf /etc/samba

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/macip.sh

        chmod 777 scripts/macip.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/mkuniq.sh

        chmod 777 scripts/mkuniq.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/getupdt.sh

        chmod 777 scripts/getupdt.sh

        wget -N -nd -w 3 -P ${PL_DIR} --limit-rate=50k "http://192.168.200.6/files/mp4/ihdn mrkt 14051500.mp4"

        cp "${PL_DIR}/ihdn mrkt 14051500.mp4" ${MP4_DIR}

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/inetup.sh

        chmod 777 scripts/inetup.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/l-ctrl.sh

        chmod 777 scripts/l-ctrl.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/grabfiles.sh

        chmod 777 scripts/grabfiles.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/ihdn_play.sh

        chmod 777 scripts/ihdn_play.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/ihdn_tests.sh

        chmod 777 scripts/ihdn_tests.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/mkplay.sh

        chmod 777 scripts/mkplay.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/playlist.sh

        chmod 777 scripts/playlist.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/process_playlist.sh

        chmod 777 scripts/process_playlist.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/dropbox_uploader.sh

        chmod 777 scripts/dropbox_uploader.sh

        wget -N -nd -w 3 -O $HOME/.dropbox_uploader --limit-rate=50k http://192.168.200.6/files/dropbox_uploader.conf

        # rpi-wiggle MUST be last item, as it reboots the system

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/rpi-wiggle.lic

        cat ${TEMP_DIR}/rpi-wiggle.lic

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/rpi-wiggle.sh

        chmod 777 ${TEMP_DIR}/rpi-wiggle.sh

    else

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k "https://www.dropbox.com/s/ow9c1fko7yn3q52/AEBL_00.png"

        sudo mv ${TEMP_DIR}/AEBL_00.png /etc

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k "https://www.dropbox.com/s/z2h9psou2w5zub9/asplash.sh"

        sudo mv ${TEMP_DIR}/asplash.sh /etc/init.d

        sudo chmod a+x /etc/init.d/asplash.sh

        sudo insserv /etc/init.d/asplash.sh

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k "https://www.dropbox.com/s/o1owd7yj7abbguf/ihdn_det_bootup.sh"

        cp ${TEMP_DIR}/ihdn_det_bootup.sh ${TEMP_DIR}/bootup.sh
        rm ${TEMP_DIR}/ihdn_det_bootup.sh

        sudo rm /etc/init.d/bootup.sh
        sudo mv ${TEMP_DIR}/bootup.sh /etc/init.d
        sudo chmod 755 /etc/init.d/bootup.sh
        sudo update-rc.d bootup.sh defaults

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k "https://www.dropbox.com/s/x72m04umy044jpd/aeblcron.tab"

        cat ${TEMP_DIR}/aeblcron.tab > $CRONCOMMFILE

        crontab "${CRONCOMMFILE}"
        rm $CRONCOMMFILE
        rm ${TEMP_DIR}/aeblcron.tab

        wget -N -nd -w 3 -P $HOME --limit-rate=50k "https://www.dropbox.com/s/pjweic24wonfoyo/smb.conf"

        sudo rm /etc/samba/smb.conf

        sudo mv $HOME/smb.conf /etc/samba

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/hjmrvwqmzefhnhy/macip.sh"

        chmod 777 scripts/macip.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/ryag5pha0qzjndg/mkuniq.sh"

        chmod 777 scripts/mkuniq.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/7e2png1lmzzmzxh/getupdt.sh"

        chmod 777 scripts/getupdt.sh

        wget -N -nd -w 3 -P ${PL_DIR} --limit-rate=50k "https://www.dropbox.com/s/hy0mg93d8pia2ig/ihdn%20mrkt%2014051500.mp4"

        cp "${PL_DIR}/ihdn mrkt 14051500.mp4" ${MP4_DIR}

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/0tponu7z348osrs/inetup.sh"

        chmod 777 scripts/inetup.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/k1ifbgmvhjh83na/l-ctrl.sh"

        chmod 777 scripts/l-ctrl.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/c2j6ygj5957wrdh/grabfiles.sh"

        chmod 777 scripts/grabfiles.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/bn1h9dkoze97lhh/ihdn_play.sh"

        chmod 777 scripts/ihdn_play.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/vtm7naqg4sbq2wh/ihdn_tests.sh"

        chmod 777 scripts/ihdn_tests.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/m4fe1tu5luvvzni/mkplay.sh"

        chmod 777 scripts/mkplay.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/x255v1htcz9lblt/playlist.sh"

        chmod 777 scripts/playlist.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/s9jv5gi0ybr3ura/process_playlist.sh"

        chmod 777 scripts/process_playlist.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/4xithl0z7mnq7vh/dropbox_uploader.sh"

        chmod 777 scripts/dropbox_uploader.sh

        wget -N -nd -w 3 -O $HOME/.dropbox_uploader --limit-rate=50k "https://www.dropbox.com/s/3zewhjwwqyyhfug/dropbox_uploader.conf"

        # rpi-wiggle MUST be last item, as it reboots the system

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k "https://www.dropbox.com/s/kdz6t912uifgzyn/rpi-wiggle.lic"

        cat ${TEMP_DIR}/rpi-wiggle.lic

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k "https://www.dropbox.com/s/60igiqj34ofaira/rpi-wiggle.sh"

        chmod 777 ${TEMP_DIR}/rpi-wiggle.sh

    fi

    $HOME/tmpdir_maintenance/mod_Twitter/./tcli.sh -c statuses_update -s "automagic @kratt, #IHDNpi ${MACe0} registered." &

    # sleep 5 seconds to ensure system ready for reboot
    echo "Processing files.  Please wait."
    sleep 5

    # running rpi-wiggle in background so script has chance to
    # end gracefully
    sudo ${TEMP_DIR}/./rpi-wiggle.sh &

    # sleep 2 seconds so that rpi-wiggle.sh can be loaded
    # and started before it is removed
    sleep 2

    rm ${TEMP_DIR}/*

    rmdir ${TEMP_DIR}

fi

exit
# tput clear
