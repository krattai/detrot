#!/bin/bash
# runs updates
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
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
#
# This script is the one called from the getupdt.sh script and should
# probably make immediate determination between IHDN and AEBL systems
# and call respective scripts.
#
# This is the first script from clean bootup.  It should immediately
# put something to screen and audio so that people know it is working,
# and it should then loop that until it get's a .sysready lockfile.
#
# Utilize good bash methodologies as per:
# http://www.davidpashley.com/articles/writing-robust-shell-scripts/#id2382181
#

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
IPw0=$(ip addr show wlan0 | awk '/inet / {print $2}' | cut -d/ -f 1)
MACw0=$(ip link show wlan0 | awk '/ether/ {print $2}')
IPe0=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f 1)
MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')

CRONCOMMFILE="/home/pi/.tempcron"
 
# set to home directory
 
cd $HOME

touch .sysrunning

while [ -f "${HOME}/.sysrunning" ]; do

    # log .id

    cat .id >> log.txt

    if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then

        if [ ! -f "$HOME/scripts/aebl_play.sh" ] && [ ! -f "${OFFLINE_SYS}" ]; then
            if [ -f "${LOCAL_SYS}" ]; then
                wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/aebl_play.sh
            else
                wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/s1sf9f2a5380917/aebl_play.sh"
            fi
        fi

        if [ -f "$HOME/scripts/aebl_play.sh" ]; then
            chmod 777 scripts/./aebl_play.sh

            scripts/./aebl_play.sh
        fi
    fi

    if [ -f "${IHDN_TEST}" ] || [ -f "${IHDN_SYS}" ]; then

        if [ ! -f "$HOME/scripts/ihdn_play.sh" ] && [ ! -f "${OFFLINE_SYS}" ]; then
            if [ -f "${LOCAL_SYS}" ]; then
                wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/ihdn_play.sh
            else
                wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/bn1h9dkoze97lhh/ihdn_play.sh"
            fi
        fi

        if [ -f "$HOME/scripts/ihdn_play.sh" ]; then
            chmod 777 scripts/./ihdn_play.sh

            scripts/./ihdn_play.sh
        fi
    fi

    if [ -f "${IHDN_TEST}" ] || [ -f "${IHDN_SYS}" ]; then

        if [ ! -f "$HOME/scripts/ihdn_tests.sh" ] && [ ! -f "${OFFLINE_SYS}" ]; then
            if [ -f "${LOCAL_SYS}" ]; then
                wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/ihdn_tests.sh
            else
                wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/vtm7naqg4sbq2wh/ihdn_tests.sh"
            fi
        fi

        if [ -f "$HOME/scripts/ihdn_tests.sh" ] && [ ! -f "${HOME}/.syschecks" ]; then
            chmod 777 scripts/./ihdn_tests.sh

            scripts/./ihdn_tests.sh &
        fi
    fi

# if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
#     echo "Check if MAC is ending :5a" >> log.txt
#     echo "MAC Address is created as: $MACe0"
#     echo $(date +"%T") >> log.txt
#     if [ "${MACe0}" == 'b8:27:eb:37:07:5a' ]; then
#         echo "MAC is ending :5a so touching .aeblsys_test." >> log.txt
#         touch .aeblsys_test
#     fi
# fi

    if [ -f "${AEBL_TEST}" ] && [ ! -f "${HOME}/.aeblv0090beta01" ]; then
        echo "MAC is ending :d7 so touching .aeblv0090beta01." >> log.txt
        touch .aeblv0090beta01
    fi

    if [ -f "${AEBL_SYS}" ] && [ ! -f "${HOME}/.aeblv0090beta01" ]; then
        echo "MAC is ending :d7 so touching .aeblv0090beta01." >> log.txt
        touch .aeblv0090beta01
    fi

    if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
        # log current IPs
        echo "Current IPs as follows:" >> log.txt
        echo "WAN IP: $IPw0" >> log.txt
        echo "LAN IP: $IPe0" >> log.txt

        # echo $(date +"%y-%m-%d")
        # echo $(date +"%T")

        # echo $(date +"%y-%m-%d")$(date +"%T")$MACe0$IPw0
        echo $(date +"%y-%m-%d") >> log.txt
        echo $(date +"%T") >> log.txt

        # temp check
        # log host $HOME dirctory

        # echo "Current home directory" >> log.txt
        # echo $(date +"%T") >> log.txt
        # ls -al >> log.txt

        echo "Current pl directory" >> log.txt
        echo $(date +"%T") >> log.txt
        ls -al pl >> log.txt
    fi

    if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
        echo "Running update." >> log.txt
        echo $(date +"%T") >> log.txt

    else
        if [ ! -f "${FIRST_RUN_DONE}" ]; then
            wget -t 1 -N -nd "https://www.dropbox.com/s/7e2png1lmzzmzxh/getupdt.sh" -O $HOME/scripts/getupdt.sh

            chmod 777 scripts/getupdt.sh
        fi
    fi

    # Check nothing new
    if [ -f "${NOTHING_NEW}" ]; then
        echo "No files to grab."
    else

        if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
            echo "Getting grabfiles.sh" >> log.txt
            echo $(date +"%T") >> log.txt
        fi
        # check network
        #
        # this will fail if local network but no internet
        # also fails if network was available but drops

        if [ ! -f "${OFFLINE_SYS}" ]; then
            if [ -f "${LOCAL_SYS}" ]; then
                wget -t 1 -N -nd http://192.168.200.6/files/grabfiles.sh -O $HOME/scripts/grabfiles.sh

            else
                wget -t 1 -N -nd "https://www.dropbox.com/s/c2j6ygj5957wrdh/grabfiles.sh" -O $HOME/scripts/grabfiles.sh

            fi

            chmod 777 scripts/grabfiles.sh
            rm index*

            scripts/./grabfiles.sh

        fi

    fi

    if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
        echo "Starting the following playlist set." >> log.txt
        cat .playlist >> log.txt
        echo $(date +"%T") >> log.txt
    fi

    if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ] && [ ! -f "${NOTHING_NEW}" ]; then
        echo "Setting system to not check updates with .nonew" >> log.txt
        echo $(date +"%T") >> log.txt
        touch .nonew
    fi

    if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
        echo "Done playing playlist set." >> log.txt
        echo $(date +"%T") >> log.txt
    fi

done

# if .sysrunning token cleared, loop back to getupdt.sh

scripts/./getupdt.sh &

exit

# reboot system
