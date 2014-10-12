#!/usr/bin/env bash
#
# sets system to IHDN AEBL v00.80 beta 01
#
# Copyright (C) 2014 IHDN, Uvea I. S., Kevin Rattai
#

LOCAL_SYS="/home/pi/.local"
NETWORK_SYS="/home/pi/.network"
OFFLINE_SYS="/home/pi/.offline"

IHDN_TEST="/home/pi/.ihdntest"
IHDN_SYS="/home/pi/.ihdnsys"
MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')


cd $HOME

if [ ! -f "${OFFLINE_SYS}" ]; then
    if [ -f "${LOCAL_SYS}" ]; then
        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/lctrl.ctab

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/chckint.ctab

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/inetup.sh

        chmod 777 scripts/inetup.sh

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/cronrem.sh

        chmod 777 scripts/cronrem.sh

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/cronadd.sh

        chmod 777 scripts/cronadd.sh

        rm scripts/l-ctrl.sh

        rm scripts/synfilz.sh

        scripts/./cronrem.sh

        scripts/./cronadd.sh
    else
        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/4fjx8hiqncpfyto/lctrl.ctab"

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/9v326l6n8bjj3gj/chckint.ctab"

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/0tponu7z348osrs/inetup.sh"

        chmod 777 scripts/inetup.sh

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/4gee63a4fb06zjl/cronrem.sh"

        chmod 777 scripts/cronrem.sh

        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/o86jbuqc81esv83/cronadd.sh"

        chmod 777 scripts/cronadd.sh

        rm scripts/l-ctrl.sh

        rm scripts/synfilz.sh

        scripts/./cronrem.sh

        scripts/./cronadd.sh
    fi


fi

exit 0
