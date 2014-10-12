#!/bin/bash
# gets update scripts
#
# Copyright (C) 2014 IHDN, Uvea I. S., Kevin Rattai
#
# This eventually is the control script.  It will be a cron job
# that will check with Master Control and grab the control file.
# The control file will contain all the relevant information that
# will allow the box to manage its local operations.

# wget -N -nd http://ihdn.ca/ftp/ads/update.sh -O $HOME/update.sh

# cd $HOME
# ./update.sh

cd $HOME

if [ -f "${HOME}/mkuniq.sh" ]; then
    mv mkuniq.sh scripts
fi

if [ -f "${HOME}/macip.sh" ]; then
    mv macip.sh scripts
fi

scripts/./mkuniq.sh &

# clear all network check files

rm index*

# example:  getting from dropbox
# wget -N -nd "https://www.dropbox.com/s/sbz7tzlp71hrr8l/bootup.sh" -O $HOME/scripts/bootup.sh

# wget -N -nd http://192.168.200.6/files/update.sh -O $HOME/scripts/update.sh

# check network
wget -q --tries=5 --timeout=20 http://google.com
if [[ $? -eq 0 ]]; then
        rm index*
        echo "Online"
        wget -t 1 -N -nd "https://www.dropbox.com/s/if3ew96beyzx5bq/update.sh" -O $HOME/scripts/update.sh

        chmod 777 scripts/update.sh
else
        echo "Offline"
fi


scripts/./update.sh &
