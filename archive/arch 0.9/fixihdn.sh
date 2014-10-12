#!/bin/bash
# Script to fix IHDN Pi systems
#
# Copyright (C) 2014 IHDN, Uvea I. S., Kevin Rattai
#
# wget -N -r -nd -l2 -w 3 -P $HOME --limit-rate=50k http://192.168.200.6/files/fixihdn.sh; chmod 777 $HOME/fixihdn.sh; $HOME/./fixihdn.sh; rm $HOME/fixihdn.sh

cd $HOME

# check network
# wget -q --tries=5 --timeout=20 http://google.com
wget -q --tries=5 --timeout=20 http://192.168.200.6
if [[ $? -eq 0 ]]; then
    rm index*

    wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/getupdt.sh

    chmod 777 scripts/getupdt.sh

    wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/update.sh

    chmod 777 scripts/update.sh

    wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/grabfiles.sh

    chmod 777 scripts/grabfiles.sh

    wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/macip.sh

    chmod 777 scripts/macip.sh

    wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/mkuniq.sh

    chmod 777 scripts/mkuniq.sh

    wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/bootup.sh

    sudo rm /etc/init.d/bootup.sh
    sudo mv /home/pi/scripts/bootup.sh /etc/init.d
    sudo chmod 755 /etc/init.d/bootup.sh
    sudo update-rc.d bootup.sh defaults

    rm scripts/l-ctrl.sh

    wget -r -nd -nc -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/l-ctrl.sh

    chmod 777 scripts/l-ctrl.sh


    wget -nc -nd http://192.168.200.6/files/inetup.sh -O $HOME/scripts/inetup.sh

    chmod 777 scripts/inetup.sh

    wget -N -nd http://192.168.200.6/files/playlist.sh -O $HOME/scripts/playlist.sh

    chmod 777 scripts/playlist.sh

    wget -N -nd http://192.168.200.6/files/process_playlist.sh -O $HOME/scripts/process_playlist.sh

    chmod 777 scripts/process_playlist.sh

else
    wget -q --tries=5 --timeout=20 http://google.com
    if [[ $? -eq 0 ]]; then

        rm index*

        rm .id

        wget -t 1 -N -nd "https://www.dropbox.com/s/7e2png1lmzzmzxh/getupdt.sh" -O $HOME/scripts/getupdt.sh

        chmod 777 scripts/getupdt.sh

        wget -t 1 -N -nd "https://www.dropbox.com/s/if3ew96beyzx5bq/update.sh" -O $HOME/scripts/update.sh

        chmod 777 scripts/update.sh

        wget -t 1 -N -nd "https://www.dropbox.com/s/c2j6ygj5957wrdh/grabfiles.sh" -O $HOME/scripts/grabfiles.sh

        chmod 777 scripts/grabfiles.sh

        wget -t 1 -N -nd "https://www.dropbox.com/sh/9lxzyf9i75ogh58/AAC2xNOFOSojc14brCziBPgua/mkuniq.sh" -O $HOME/mkuniq.sh

        chmod 777 mkuniq.sh

        wget -t 1 -N -nd "https://www.dropbox.com/s/hjmrvwqmzefhnhy/macip.sh" -O $HOME/macip.sh

        chmod 777 macip.sh

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/sbz7tzlp71hrr8l/bootup.sh"

        sudo rm /etc/init.d/bootup.sh
        sudo mv /home/pi/scripts/bootup.sh /etc/init.d
        sudo chmod 755 /etc/init.d/bootup.sh
        sudo update-rc.d bootup.sh defaults

        wget -N -nd "https://www.dropbox.com/s/x255v1htcz9lblt/playlist.sh" -O $HOME/scripts/playlist.sh 

        chmod 777 scripts/playlist.sh

        wget -N -nd "https://www.dropbox.com/s/s9jv5gi0ybr3ura/process_playlist.sh" -O $HOME/scripts/process_playlist.sh

        chmod 777 scripts/process_playlist.sh

    fi
fi

touch $HOME/.systemfixed

sudo reboot
# tput clear
exit 0
