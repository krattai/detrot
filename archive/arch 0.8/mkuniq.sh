#!/bin/sh
# make unique id
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai

ID_FILE="${HOME}/.id"

MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')
 
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
    $HOME/tmpdir_maintenance/mod_Twitter/./tcli.sh -c statuses_update -s "automagic To @kratt, #IHDNpi registered ${U_ID} by ifTTT Tweet -> SMS."

else

    echo "File exists."

fi

 
# EndOfFile
