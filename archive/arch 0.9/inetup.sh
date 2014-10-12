#!/bin/bash

# wget useful parameters
#
# -c count  ie. 1
# -I interface  either an address, or an interface name
# -q  quiet  output.  Nothing is displayed except the summary lines at startup time and when finished
# --tries=10
# --timeout=20

LOCAL_SYS="/home/pi/.local"
NETWORK_SYS="/home/pi/.network"
OFFLINE_SYS="/home/pi/.offline"
AEBL_TEST="/home/pi/.aebltest"
AEBL_SYS="/home/pi/.aeblsys"
IHDN_TEST="/home/pi/.ihdntest"
IHDN_SYS="/home/pi/.ihdnsys"

cd $HOME

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
    echo "Checking network status." >> log.txt
    echo $(date +"%T") >> log.txt
fi

# Discover network availability
#
# This was the old way of checking network up
#
# wget -q --tries=5 --timeout=20 http://google.com
#
# if [[ $? -eq 0 ]]; then
#     touch .network
#     echo "Internet available."
# else
#     rm .network
# fi
#
# The following is the newer, cleaner, faster way
#
# for i in $@
# do
# ping -c 1 $i &> /dev/null
#
# if [ $? -ne 0 ]; then
# 	echo "`date`: ping failed, $i host is down!" | mail -s "$i host is down!" my@email.address 
# fi
# done
#
# For right now, just checking once per cron and should probably keep
# it that way to ensure low bandwidth use, although once per minute
# should be standard way to check up or down.  Alternately from cron,
# a sleep -s 60 could be added to script and simply have script load on
# boot and keep running in a daemon like way

ping -c 1 184.71.76.158

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
else
    rm .offline
fi

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
    echo "Network check complete." >> log.txt
    echo $(date +"%T") >> log.txt
fi

exit
