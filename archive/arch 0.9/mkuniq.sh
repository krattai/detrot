#!/bin/sh
# make unique id
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai

LOCAL_SYS="/home/pi/.local"
NETWORK_SYS="/home/pi/.network"
OFFLINE_SYS="/home/pi/.offline"
FIRST_RUN_DONE="/home/pi/.firstrundone"
AEBL_TEST="/home/pi/.aebltest"
AEBL_SYS="/home/pi/.aeblsys"
IHDN_TEST="/home/pi/.ihdntest"
IHDN_SYS="/home/pi/.ihdnsys"

TYPE_SYS="unknown"

ID_FILE="${HOME}/.id"
IPw0=$(ip addr show wlan0 | awk '/inet / {print $2}' | cut -d/ -f 1)
IPe0=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f 1)


MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')

if [ -f "${AEBL_TEST}" ]; then
    TYPE_SYS="AEBLtest"
fi
 
if [ -f "${AEBL_SYS}" ]; then
    TYPE_SYS="AEBLsystem"
fi
 
if [ -f "${IHDN_TEST}" ]; then
    TYPE_SYS="IHDN/AEBLtest"
fi
 
if [ -f "${IHDN_SYS}" ]; then
    TYPE_SYS="IHDNpi"
fi


echo "MAC Address: $MACe0"

echo $(date +"%y-%m-%d")
echo $(date +"%T")

# check file doesn't exist
if [ ! -f "${ID_FILE}" ]; then

    # create uid
#    U_ID="${HOME}/$(date +"%y-%m-%d")$(date +"%T")$MACe0$IPw0"
    U_ID="$(date +"%y-%m-%d")$(date +"%T")$MACe0$IPw0"

    # create file
#    touch ${U_ID}
#    echo ${U_ID} > ${U_ID}
#    echo $(date +"%y-%m-%d")$(date +"%T")$MACe0$IPw0 > ${ID_FILE}
    echo ${U_ID} > ${ID_FILE}

    $HOME/scripts/./macip.sh >> ${ID_FILE}

    # create local store id file
#    echo $(date +"%y-%m-%d")$(date +"%T")$MACe0$IPw0 > ${ID_FILE}

    # put to dropbox
    $HOME/scripts/./dropbox_uploader.sh upload ${ID_FILE} /${U_ID}

    # Tweet -> SMS announce
#     $HOME/tmpdir_maintenance/mod_Twitter/./tcli.sh -c statuses_update -s "automagic To @kratt, #${TYPE_SYS} registered ${U_ID} ${IPw0} ${IPe0} by ifTTT Tweet -> SMS."

else

    echo "File exists."

fi

exit
 
# EndOfFile
