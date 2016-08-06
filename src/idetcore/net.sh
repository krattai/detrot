#!/bin/bash


VPN_SYS=".vpn_on"

i="0"
hostn=$(cat /etc/hostname)

while [ $i -lt 1 ]
do
hostn=$(cat /etc/hostname)

# Check VPN tun for master control IP
#
# this works
ping -c 1 10.8.0.1

if [ $? -eq 0 ]; then
    echo naw9Tb2r | sudo -S touch $VPN_SYS
    echo "VPN available."
else
    hostn=$(cat /etc/hostname)
    mosquitto_pub -d -t ihdn/alive -m "$(date) : $hostn attempting to restart openvpn." -h "ihdn.ca"
    echo !password! | sudo -S rm $VPN_SYS
    echo !password! | sudo -S service openvpn restart
fi

# i=$[$i+1]
sleep 1700
done

exit

