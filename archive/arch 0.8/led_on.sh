#!/bin/bash
# 
# May 14, 2014 Larry
#
#Ver 
# 
# send led GPIO 23 value 1.

# Set up GPIO 23 and set to output

echo "23" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio23/direction
echo "1" > /sys/class/gpio/gpio23/value

# Clean up
echo "23" > /sys/class/gpio/unexport

exit 0
 
