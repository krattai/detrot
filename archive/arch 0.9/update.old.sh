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
# This script should probably loop and simply watch for .sysready and ! .sysready states.

# this was used to set keyboard LED for detector hardware to know
# not to process

# xset led 3

# set to home directory

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
 
 
cd $HOME


# log .id

cat .id >> log.txt

if [ ! -f "${OFFLINE_SYS}" ] && [ ! -f "${HOME}/scripts/macip.sh" ]; then
    wget -t 1 -N -nd "https://www.dropbox.com/s/hjmrvwqmzefhnhy/macip.sh" -O $HOME/scripts/macip.sh
    wget -t 1 -N -nd "https://www.dropbox.com/s/ryag5pha0qzjndg/mkuniq.sh" -O $HOME/scripts/mkuniq.sh
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

if [ -f "${IHDN_TEST}" ] || [ -f "${IHDN_SYS}" ]; then

    if [ ! -f "${OFFLINE_SYS}" ] && [ -f "${LOCAL_SYS}" ]; then
        wget -N -r -nd -l2 -w 3 -P $HOME --limit-rate=50k http://192.168.200.6/files/ihdncron.tab
    else
        wget -N -r -nd -l2 -w 3 -P $HOME --limit-rate=50k "https://www.dropbox.com/s/c4f0djbwgui8ygt/ihdncron.tab"
    fi

    if [ ! -f "${HOME}/.ihdnaeblv0079beta01" ] && [ ! -f "${HOME}/.ihdnaeblv0080beta01" ]; then
        cat /home/pi/ihdncron.tab > $CRONCOMMFILE

        crontab "${CRONCOMMFILE}"
        rm $CRONCOMMFILE
        rm $HOME/ihdncron.tab
        rm .ihdnaeblv0079beta01
        rm .ihdnaeblv0080beta01
    fi
fi

if [ -f "${IHDN_TEST}" ] && [ ! -f "${HOME}/.ihdnaeblv0079beta01" ]; then
    echo "MAC is ending :d7 so touching .ihdnaeblv0079beta01." >> log.txt
    touch .ihdnaeblv0079beta01
fi

if [ -f "${IHDN_SYS}" ] && [ ! -f "${HOME}/.ihdnaeblv0079beta01" ]; then
    echo "${IHDN_SYS} so touching .ihdnaeblv0079beta01." >> log.txt
    touch .ihdnaeblv0079beta01
fi

if [ -f "${IHDN_TEST}" ] && [ ! -f "${HOME}/.ihdnaeblv0080beta01" ] && [ ! -f "${OFFLINE_SYS}" ]; then
    if [ -f "${LOCAL_SYS}" ]; then
        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/ihdnaeblv0079beta01_set.sh

        chmod 777 scripts/ihdnaeblv0079beta01_set.sh

        scripts/./ihdnaeblv0079beta01_set.sh

        touch .ihdnaeblv0080beta01
    else
        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/oh1gb1vgixwnv2n/ihdnaeblv0079beta01_set.sh"

        chmod 777 scripts/ihdnaeblv0079beta01_set.sh

        scripts/./ihdnaeblv0079beta01_set.sh

        touch .ihdnaeblv0080beta01
    fi

fi

if [ -f "${AEBL_TEST}" ] && [ ! -f "${HOME}/.aeblv0090beta01" ]; then
    echo "MAC is ending :d7 so touching .aeblv0090beta01." >> log.txt
    touch .aeblv0090beta01
fi

if [ -f "${AEBL_SYS}" ] && [ ! -f "${HOME}/.aeblv0090beta01" ]; then
    echo "MAC is ending :d7 so touching .aeblv0090beta01." >> log.txt
    touch .aeblv0090beta01
fi

if [ "${MACe0}" == 'b8:27:eb:2c:41:d7' ] && [ ! -f "${IHDN_TEST}" ]; then
    echo "MAC is ending :d7 so touching .ihdntest." >> log.txt
    touch .ihdntest

    # Tweet -> SMS announce
    $HOME/tmpdir_maintenance/mod_Twitter/./tcli.sh -c statuses_update -s "automagic msg #IHDNpi ${MACe0} now IHDN AEBL test sys." &

fi

if [ "${MACe0}" == 'b8:27:eb:e3:0d:f8' ] && [ ! -f "${HOME}/.ihdnfol25" ]; then
    if [ ! -f "${OFFLINE_SYS}" ]; then
        echo "MAC is ending :f8 so touching .ihdnfol25." >> log.txt
        touch .ihdnfol25
        rm .id

        scripts/./mkuniq.sh &

        # Tweet -> SMS announce
        $HOME/tmpdir_maintenance/mod_Twitter/./tcli.sh -c statuses_update -s "automagic msg #Brent_and_Larry #IHDNpi studio test unit ${MACe0} now re-registered for channel 25." &

    fi

fi

if [ "${MACe0}" == 'b8:27:eb:a7:23:94' ] && [ ! -f "${HOME}/.ihdnfol26" ]; then
    if [ ! -f "${OFFLINE_SYS}" ]; then
        echo "MAC is ending :94 so touching .ihdnfol26." >> log.txt
        touch .ihdnfol26
        rm .id

        scripts/./mkuniq.sh &

        # Tweet -> SMS announce
        $HOME/tmpdir_maintenance/mod_Twitter/./tcli.sh -c statuses_update -s "automagic msg #Brent_and_Larry #IHDNpi ${MACe0} now re-registered for channel 26 at Robert E. Steen Community Centre." &

    fi

fi

if [ -f "${HOME}/.ihdnfol26" ] && [ ! -f "${OFFLINE_SYS}" ]; then
#     echo "List of Channel 26 files in mp4 folder" >> log.txt
#     ls -al mp4 >> log.txt

    echo "Channel 26 on this system." >> log.txt

    wget -t 1 -N -nd "https://www.dropbox.com/s/h8st6ech35eae2n/grbchan26.sh" -O $HOME/scripts/grbchan26.sh

    chmod 777 scripts/grbchan26.sh

    if [ ! -f "${HOME}/.getchan26" ]; then
        echo "Grabbing new Channel 26 files." >> log.txt
        scripts/./grbchan26.sh &
    fi
fi

if [ -f "${HOME}/.ihdnfol26" ]; then
    if [ ! -f "${HOME}/pl/ArtMomentClean.mp4" ] || [ ! -f "${HOME}/pl/RAStennisMASre.mp4" ]; then
        mv pl/*.mp4 mp4
        mv mp4/ArtMomentClean.mp4 pl
        mv mp4/RAStennisMASre.mp4 pl
        rm .newpl
    fi
fi

# if [ -f "${HOME}/.ihdnfol26" ]; then
#     mkdir chan26tmp
#     mv pl/*.mp4 chan26tmp
#     mv chan26tmp/ArtMomentClean.mp4 pl
#     mv chan26tmp/RAStennisMASre.mp4 pl
#     mv chan26tmp/*.mp4 mp4
# 
#     rmdir chan26tmp
#     rm .newpl
# fi

if [ -f "${HOME}/.newchan26" ]; then
    echo "New Channel 26 to play on this system." >> log.txt
#    mkdir chan26tmp
#    mv pl/*.mp4 chan26tmp
    mv pl/*.mp4 mp4
    mv mp4/ArtMomentClean.mp4 pl
    mv mp4/RAStennisMASre.mp4.mp4 pl

#    rmdir chan26tmp
    rm .newchan26
    rm .newpl
fi

if [ "${MACe0}" == 'b8:27:eb:3e:a8:17' ] && [ ! -f "${HOME}/.ihdnfol27" ]; then
    if [ ! -f "${OFFLINE_SYS}" ]; then
        echo "MAC is ending :17 so touching .ihdnfol27." >> log.txt
        touch .ihdnfol27
        rm .id

        scripts/./mkuniq.sh &

        # Tweet -> SMS announce
        $HOME/tmpdir_maintenance/mod_Twitter/./tcli.sh -c statuses_update -s "automagic msg #Brent_and_Larry #IHDNpi ${MACe0} now re-registered for #Hyundai demo on channel 27." &

    fi

fi

if [ -f "${HOME}/.ihdnfol27" ] && [ ! -f "${OFFLINE_SYS}" ]; then
    echo "Channel 27 on this system." >> log.txt

    wget -t 1 -N -nd "https://www.dropbox.com/s/kqecpctpzfxbc89/grbchan27.sh" -O $HOME/scripts/grbchan27.sh

    chmod 777 scripts/grbchan27.sh

    if [ ! -f "${HOME}/.getchan27" ]; then
        echo "Grabbing new Channel 27 files." >> log.txt
        scripts/./grbchan27.sh &
    fi
fi

if [ -f "${HOME}/.newchan27" ]; then
    echo "New Channel 27 to play on this system." >> log.txt
    mkdir chan27tmp
    mv pl/*.mp4 chan27tmp
    mv mp4/*.mp4 pl
    mv chan27tmp/*.mp4 mp4

    rmdir chan27tmp
    rm .newchan27
    rm .newpl
fi

# if [ "${MACe0}" == 'b8:27:eb:2c:41:d7' ] && [ -f "${IHDN_TEST}" ]; then
#     rm .ihdntest
#     rm log.txt
#     sudo reboot
# fi

if [ "${MACe0}" == 'b8:27:eb:2c:41:d7' ] && [ -f "${IHDN_SYS}" ]; then
    if [ ! -f "${IHDN_TEST}" ]; then
        touch .ihdntest
    fi
    rm .ihdnsys
#     rm log.txt
#     sudo reboot
fi


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

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
    echo "Running update." >> log.txt
    echo $(date +"%T") >> log.txt

else
    if [ ! -f "${FIRST_RUN_DONE}" ]; then
        wget -t 1 -N -nd "https://www.dropbox.com/s/7e2png1lmzzmzxh/getupdt.sh" -O $HOME/scripts/getupdt.sh

        chmod 777 scripts/getupdt.sh
    fi
fi

if [ -f "${IHDN_TEST}" ] || [ -f "${IHDN_SYS}" ]; then
    echo "!*******************!" >> log.txt
    echo "Posting log" >> log.txt
    echo $(date +"%T") >> log.txt

#     crontab -l >> log.txt

    echo "!*******************!" >> log.txt

#     if [ -f "${IHDN_TEST}" ]; then
#         ls -al >> log.txt
#         crontab -l >> log.txt

        # put to dropbox
#         $HOME/scripts/./dropbox_uploader.sh upload log.txt /${MACe0}_log.txt &
#     fi

    if [ -f "${IHDN_SYS}" ]; then
        # put to dropbox
        $HOME/scripts/./dropbox_uploader.sh upload log.txt /${MACe0}_log.txt &

        # upload to sftp server
        curl -T "$HOME/log.txt" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000000_uploads/ihdnpi_logs/${MACe0}_log.txt" &

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

# script was from original XPO boxes which ran totem
# leaving the following as an example

# totem --quit &

# wait

# wget -N -nd http://ihdn.ca/ftp/ihdn.ca.2.9.pls -O $HOME/demo/ihdn.ca.2.9.pls &

# wait

if [ -f "${NEW_PL}" ]; then
#    rm .nonew
#    sudo reboot

    if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
        echo "Setting up stored playlist." >> log.txt
        echo $(date +"%T") >> log.txt
    fi
    rm .playlist
    cp .newpl .playlist
    rm .playlistnew
else
    # make playlist

    if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
        echo "Creating new playlist." >> log.txt
        echo $(date +"%T") >> log.txt
    fi
    scripts/./playlist.sh ~/pl/*.mp4

    # scripts/./playlist.sh ~/pl/*.mp3

    cp .playlist .newpl
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

# play through the playlist

scripts/./process_playlist.sh

# starts next round of updates

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
    echo "Done playing playlist set." >> log.txt
    echo $(date +"%T") >> log.txt
fi

scripts/./getupdt.sh &

exit

# reboot system
