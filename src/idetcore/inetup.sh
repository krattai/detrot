#!/bin/bash
#
# Copyright (C) 2015 Uvea I. S., Kevin Rattai
#
# This script is a cron job script
# It checks for network and internet connectivity
# It should attempt to recover from network errors if possible.
#
# wget useful parameters
#
# -c count  ie. 1
# -I interface  either an address, or an interface name
# -q  quiet  output.  Nothing is displayed except the summary lines at startup time and when finished
# --tries=10
# --timeout=20

AEBL_TEST="/home/pi/.aebltest"
AEBL_SYS="/home/pi/.aeblsys"
IHDN_TEST="/home/pi/.ihdntest"
IHDN_SYS="/home/pi/.ihdnsys"
TEMP_DIR="/home/pi/tmp"

T_STO="/run/shm"
T_SCR="/run/shm/scripts"

LOCAL_SYS="${T_STO}/.local"
NETWORK_SYS="${T_STO}/.network"
OFFLINE_SYS="${T_STO}/.offline"


cd $HOME

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
#     echo "Checking network status." >> log.txt
#     echo $(date +"%T") >> log.txt
    hostn=$(cat /etc/hostname)
    mosquitto_pub -d -t ihdn/alive -m "$(date) : $hostn checking network status." -h "ihdn.ca" &
fi

# Discover network availability
#
# should have a way to periodically check if no network for a long time
# perhaps a network SHOULD be available, so attempt to establish
# thus:
# if inetup.sh run 4 times = 1 hour, and no network, then
# down, then up, all network interfaces and reset ticker
# or simply do this every time, if no network / offline

if [ -f "${OFFLINE_SYS}" ]; then
    sudo ifdown eth0
    sudo ifdown wlan0
    sleep 5
    sudo ifup eth0
    sudo ifup wlan0
    sleep 10
fi

# Check internet availability against master control IP
# ping -c 1 184.71.76.158
ping -c ihdn.ca

if [ $? -eq 0 ]; then
    touch $NETWORK_SYS
#    echo "Internet available."
else
    rm $NETWORK_SYS
fi

# Check local network availability against local server
# no longer relevant
# ping -c 1 192.168.200.6
# 
# if [[ $? -eq 0 ]]; then
#     touch $LOCAL_SYS
#     echo "Local network available."
# else
#     rm $LOCAL_SYS
# fi
# 
# if [ ! -f "${LOCAL_SYS}" ] && [ ! -f "${NETWORK_SYS}" ]; then
#     touch $OFFLINE_SYS
#     echo "No network available."
# else
#     rm $OFFLINE_SYS
# fi

# check IPv6 tun vs native assigned IPV6 up and if not, start/restart
#
# Might want to add something like:
# if [ "$(pgrep ctrlwtch.sh)" ]; then
#     kill $(pgrep ctrlwtch.sh)
# fi
# 
# with the logic and function in a form similar to:
# if [ "$(pgrep gogoc)" ]; then
#     sudo /etc/init.d/gogoc restart
#
#     if [[ $? -eq 0 ]]; then
#         kill $(pgrep gogoc)
#         sudo /etc/init.d/gogoc start
#     fi
# else
#     sudo /etc/init.d/gogoc start
# fi

# Check VPN tun for master control IP
# some possible examples of how to handle VPN down
# if [ -f "${OFFLINE_SYS}" ]; then
#     sudo ifdown eth0
#     sudo ifdown wlan0
#     sleep 5
#     sudo ifup eth0
#     sudo ifup wlan0
#     sleep 10
# fi
# 
# ping -c 1 10.8.0.1
# 
# if [ $? -eq 0 ]; then
#     touch $NETWORK_SYS
#     echo "Internet available."
# else
#     rm $NETWORK_SYS
# fi

# if script to be run on non-raspbian system, will likely need to set permissions:
#     http://askubuntu.com/questions/167847/how-to-run-bash-script-as-root-with-no-password
# specifically:
#   + Make the file owned by root and group root:
#   + sudo chown root.root <my script>
#   + Now set the sticky but, make it executable for all and writable only by root:
#   + sudo chmod 4755 <my script>
#   + Keep in mind if this script will allow any input or editing of files, this will also be done as root.
#
# this works
ping -c 1 10.8.0.1

if [ $? -eq 0 ]; then
    touch $VPN_SYS
    echo "VPN available."
else
    rm $VPN_SYS
    sudo service openvpn restart
fi

if [ -f "${NETWORK_SYS}" ]; then
    if [ ! -L /sys/class/net/tun ]; then
        sudo /etc/init.d/gogoc restart
    fi
fi

# nb: if doing ps on service that operates as root, use:
#     ps -au root | grep rad

exit
