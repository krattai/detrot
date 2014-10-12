#!/bin/bash
# This script preps the pi for use on the AEBL framework
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
#
# Useage:

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
    exit 1
else
    rm .offline
fi

# change hostname, from:
# http://pricklytech.wordpress.com/2013/04/24/ubuntu-change-hostname-permanently-using-the-command-line/

#Assign existing hostname to $hostn
hostn=$(cat /etc/hostname)

#Display existing hostname
# echo "Existing hostname is $hostn"

# Set new hostname $newhost
# echo "Enter new hostname: "
# read newhost
if [ -f "$HOME/ctrl/aeblsys" ]; then
    newhost="aeblsys"
fi

if [ -f "$HOME/ctrl/idetsys" ]; then
    newhost="ihdndet"
fi

if [ -f "$HOME/ctrl/irotsys" ]; then
    newhost="ihdnsys"
fi

sudo hostname ${newhost}

#change hostname in /etc/hosts & /etc/hostname
sudo sed -i "s/$hostn/$newhost/g" /etc/hosts
sudo sed -i "s/$hostn/$newhost/g" /etc/hostname

# set IPv6 enabled

sudo chown pi:pi /etc/modules
echo "ipv6" >> /etc/modules
sudo chown root:root /etc/modules

mkdir ${TEMP_DIR}
mkdir ${MP3_DIR}
mkdir ${MP4_DIR}
mkdir ${PL_DIR}
mkdir ${CTRL_DIR}
mkdir ${BIN_DIR}

chmod 777 ${MP3_DIR}
chmod 777 ${MP4_DIR}
chmod 777 ${PL_DIR}
chmod 777 ${CTRL_DIR}

export PATH=$PATH:${BIN_DIR}:$HOME/scripts

# Get necessary AEBL files
#

if [ ! -f "${OFFLINE_SYS}" ]; then

    sudo apt-get update

    sudo apt-get -y install fbi samba samba-common-bin libnss-mdns lsof

    sudo rpi-update

    if [ -f "${LOCAL_SYS}" ]; then

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/AEBL_00.png

        sudo mv ${TEMP_DIR}/AEBL_00.png /etc

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/asplash.sh

        sudo mv ${TEMP_DIR}/asplash.sh /etc/init.d

        sudo chmod a+x /etc/init.d/asplash.sh

        sudo insserv /etc/init.d/asplash.sh

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/afwbootup.sh

        sudo rm /etc/init.d/bootup.sh
        sudo mv ${TEMP_DIR}/afwbootup.sh /etc/init.d/bootup.sh
        sudo chmod 755 /etc/init.d/bootup.sh
        sudo update-rc.d bootup.sh defaults

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

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k "https://www.dropbox.com/s/sbz7tzlp71hrr8l/afwbootup.sh"

        sudo rm /etc/init.d/bootup.sh
        sudo mv ${TEMP_DIR}/afwbootup.sh /etc/init.d/bootup.sh
        sudo chmod 755 /etc/init.d/bootup.sh
        sudo update-rc.d bootup.sh defaults

        # rpi-wiggle MUST be last item, as it reboots the system

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k "https://www.dropbox.com/s/kdz6t912uifgzyn/rpi-wiggle.lic"

        cat ${TEMP_DIR}/rpi-wiggle.lic

        wget -N -nd -w 3 -P ${TEMP_DIR} --limit-rate=50k "https://www.dropbox.com/s/60igiqj34ofaira/rpi-wiggle.sh"

        chmod 777 ${TEMP_DIR}/rpi-wiggle.sh

    fi

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
