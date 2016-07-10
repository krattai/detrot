#!/bin/bash
# provides heartbeat
#
# Copyright (C) 2016 IHDN, Uvea I. S., Kevin Rattai
#
# This will send an message to announce alive and addresses

i="0"

while [ $i -lt 1 ]
do
hostn=$(cat /etc/hostname)
ext_ip4=$(dig +short myip.opendns.com @resolver1.opendns.com)
ext_ip6=$(curl icanhazip.com)
# mosquitto_pub -d -t hello/world -m "$(date) : irot LdB, online. IP is $ext_ip" -h "uveais.ca"
# mosquitto_pub -d -t uvea/alive -m "$(date) : $hostn server IP $ext_ip is online." -h "2604:8800:100:19a::2"
mosquitto_pub -d -t ihdn/alive -m "$(date) : $hostn IPv4 $ext_ip4 is online." -h "ihdn.ca"
mosquitto_pub -d -t ihdn/alive -m "$(date) : $hostn IPv6 $ext_ip6 is online." -h "ihdn.ca"

IPt0=$(ip addr show tun0 | awk '/inet / {print $2}' | cut -d/ -f 1)
mosquitto_pub -d -t ihdn/alive -m "$(date) : $hostn tun0 $IPt0 is online." -h "ihdn.ca"

# i=$[$i+1]
sleep 300
done

