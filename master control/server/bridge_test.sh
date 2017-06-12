#!/bin/bash
# Testing broker bridging as simple relay

mosquitto_sub -h 2001:5c0:1100:dd00:240:63ff:fefd:d3f1 -t "hello/#" -t "aebl/#" -t "ihdn/#" -t "uvea/#" | while IFS= read -r line
    do
        mosquitto_pub -d -t ihdn/bridge -m "$(line)" -h "ihdn.ca"

done

exit 0
