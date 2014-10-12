#!/bin/bash

# wget useful parameters
#
# -c count  ie. 1
# -I interface  either an address, or an interface name
# -q  quiet  output.  Nothing is displayed except the summary lines at startup time and when finished
# --tries=10
# --timeout=20

wget -q --tries=10 --timeout=20 http://google.com
if [[ $? -eq 0 ]]; then
        rm index*
        echo "Online"
else
        echo "Offline"
fi
