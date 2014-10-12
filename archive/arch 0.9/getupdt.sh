#!/bin/bash
# gets update scripts
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
#
# This is the first script from clean bootup.  It should immediately
# put something to screen and audio so that people know it is working,
# and it should then loop that until it get's a .sysready lockfile.
#
# Utilize good bash methodologies as per:
# http://www.davidpashley.com/articles/writing-robust-shell-scripts/#id2382181
#
# This script should probably loop and simply watch for .sysready
# and ! .sysready states.
#
# wget -N -nd http://ihdn.ca/ftp/ads/update.sh -O $HOME/update.sh

# cd $HOME
# ./update.sh

LOCAL_SYS="/home/pi/.local"
NETWORK_SYS="/home/pi/.network"
OFFLINE_SYS="/home/pi/.offline"
FIRST_RUN_DONE="/home/pi/.firstrundone"
AEBL_TEST="/home/pi/.aebltest"
AEBL_SYS="/home/pi/.aeblsys"
IHDN_TEST="/home/pi/.ihdntest"
IHDN_SYS="/home/pi/.ihdnsys"
TEMP_DIR="/home/pi/tmp"

cd $HOME

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ] && [ ! -f "${HOME}/.optimized" ]; then
    sudo service dbus stop
    sudo mount -o remount,size=128M /dev/shm
    echo -n performance | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    sudo service triggerhappy stop
    sudo killall console-kit-daemon
    sudo killall polkitd
    killall gvfsd
    killall dbus-daemon
    killall dbus-launch
    touch .optimized

#  Can't do the following, on first run, network not yet established
#     wget -N -r -nd -l2 -w 3 -P ${TEMP_DIR} --limit-rate=50k http://192.168.200.6/files/bootup.sh

#     sudo rm /etc/init.d/bootup.sh
#     sudo mv ${TEMP_DIR}/bootup.sh /etc/init.d
#     sudo chmod 755 /etc/init.d/bootup.sh
#     sudo update-rc.d bootup.sh defaults
#     sudo rm ${TEMP_DIR}/bootup.sh

fi

if [ ! -f "${HOME}/.mkplayrun" ]; then
    scripts/./mkplay.sh &
fi

if [ ! -f "${FIRST_RUN_DONE}" ]; then
    chmod 777 $HOME/pl
    chmod 777 $HOME/aud
    chmod 777 $HOME/mp4
    chmod 777 $HOME/mp3

    rm .id
    rm $HOME/scripts/create-ihdn.sh
    rm $HOME/scripts/create-aebl.sh
    touch .firstrundone
fi

if [ -f ".omx_playing" ]; then
    rm .omx_playing
fi

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
    echo "~~~~~~~~~~~~~~~~~~~~~~~~" >> log.txt
    echo "Getupdt.sh" >> log.txt
    echo $(date +"%T") >> log.txt
fi

# Discover network availability if not previously tested
if [ ! -f "${LOCAL_SYS}" ] && [ ! -f "${NETWORK_SYS}" ] && [ ! -f "${OFFLINE_SYS}" ]; then

    scripts/./inetup.sh

fi

if [ ! -f "${OFFLINE_SYS}" ]; then
    scripts/./mkuniq.sh &

    ID_FILE="${HOME}/ctrl/ip.txt"
    IPw0=$(ip addr show wlan0 | awk '/inet / {print $2}' | cut -d/ -f 1)
    IPe0=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f 1)

    echo ${IPw0} > ${ID_FILE}
    echo ${IPe0} >> ${ID_FILE}

    ID_FILE="${HOME}/ctrl/ip.txt"
    IPw0=$(ip addr show wlan0 | awk '/inet / {print $2}' | cut -d/ -f 1)
    IPe0=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f 1)

    echo ${IPw0} > ${ID_FILE}
    echo ${IPe0} >> ${ID_FILE}

    if [ ! -f "${HOME}/scripts/ctrlwtch.sh" ]; then

        if [ -f "${LOCAL_SYS}" ]; then
            wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/ctrlwtch.sh

        else
            wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/wa03rjttknx2grh/ctrlwtch.sh"
        fi

        chmod 777 "$HOME/scripts/ctrlwtch.sh"

    fi
fi

$HOME/scripts/./ctrlwtch.sh &

# clear all network check files

rm index*

# check network
#
# this will fail if local network but no internet
# also fails if network was available but drops

if [ ! -f "${OFFLINE_SYS}" ]; then
    if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
        echo "Getting update.sh" >> log.txt
        echo $(date +"%T") >> log.txt
    fi
    if [ -f "${LOCAL_SYS}" ]; then
        rm index*

        if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
            echo "!!~~!!~~!!" >> log.txt
            echo "Starting wget update.sh" >> log.txt
            echo $(date +"%T") >> log.txt
        fi

        wget -t 1 -N -nd "http://192.168.200.6/files/update.sh" -O $HOME/scripts/update.sh

        if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
            echo "!!~~!!~~!!" >> log.txt
            echo "Done wget update.sh" >> log.txt
            echo $(date +"%T") >> log.txt
        fi

        chmod 777 scripts/update.sh

        if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
            echo "ran chmod on update.sh update.sh" >> log.txt
            echo $(date +"%T") >> log.txt
        fi

    else
        rm index*

        wget -t 1 -N -nd "https://www.dropbox.com/s/if3ew96beyzx5bq/update.sh" -O $HOME/scripts/update.sh

        chmod 777 scripts/update.sh

    fi

    if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
        echo "Ending update.sh if statement" >> log.txt
        echo $(date +"%T") >> log.txt
    fi


fi

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
    echo "Going to run update.sh" >> log.txt
    echo $(date +"%T") >> log.txt
fi

scripts/./update.sh &

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
    echo "Ending getupdt.sh" >> log.txt
    echo $(date +"%T") >> log.txt
fi

exit
