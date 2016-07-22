#!/bin/bash
#
# Copyright (C) 2016 IHDN, Uvea I. S., Kevin Rattai
#
# This code specifically watches for IR and sets token for three seconds
#
# It may also, eventually check for kill
#
# Variables *****
#  DD = detect input
#  EE = eye input
#  HH = HDMI input
#  KK = kill switch
#  g1 = Green LED default is power led with pi.
#  r1 = Red LED indicate sleep mode
#  r2 = Relay output
#  cc = sleep counter

# additional constants
T_STO="/run/shm"
T_SCR="/run/shm/scripts"

OUT="/home/pi/.out"
SHORT="/home/pi/.short"
KILL="${T_STO}/.kill"
IR="${T_STO}/.ir"

# Set Variable Defaults *****
DD=0
EE=0
HH=0
KK=1
g1=0
r1=0
r2=0
cc=0


# Initialize PINS *****

# Setup GPIO 5, set to output, and send 1 for Red LED
echo "5" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio5/direction
echo "1" > /sys/class/gpio/gpio5/value

# Setup GPIO 6, set to output, and send 0 for Green LED
echo "6" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio6/direction
echo "0" > /sys/class/gpio/gpio6/value

# Setup GPIO 17, set to output, and send 1 for CHNL Control
echo "17" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio17/direction
echo "1" > /sys/class/gpio/gpio17/value

# Setup GPIO 27, set to input for CHNL 1 check
echo "27" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio27/direction

# Setup GPIO 22, set to input for CHNL 2 check
echo "22" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio22/direction

# Setup GPIO 26, set to input for detect
echo "26" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio26/direction

# Setup GPIO 4, set to input for IR detect
echo "4" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio4/direction

# Setup GPIO 24, set to input for kill switch
echo "24" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio24/direction

# Setup GPIO 25, set to output, and send 0 for kill LED
echo "25" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio25/direction
echo "0" > /sys/class/gpio/gpio25/value


# Start Loop Program ****************************
while :
do
  # nb:  kill should turn off all LEDs on back panel, except green pwr
  #      also, kill should place unit into test mode - refer to Larry's notes
  #      - turn all LEDs off except red LED on front
  #      - green power button will remain as light green
  if [ -f "${IR}" ]; then
    echo "1" > /sys/class/gpio/gpio25/value
    hostn=$(cat /etc/hostname)
    mosquitto_pub -d -t ihdn/alladin/log -m "$(date) : $hostn IR triggered." -h "ihdn.ca" &
#   The following would be the equavalent of sleep 1h but with ability to do things:
#
#     This is POSIX compliant and works with /bin/sh
#     secs=3600                         # Set interval (duration) in seconds.
#     endTime=$(( $(date +%s) + secs )) # Calculate end time.
#
#     while [ $(date +%s) -lt $endTime ]; do  # Loop until interval has elapsed.
        # ...
#     done
#
#     This is not POSIX but will work in /bin/bash
#     secs=3600   # Set interval (duration) in seconds.
#
#     SECONDS=0   # Reset $SECONDS; counting of seconds will (re)start from 0(-ish).
#     while (( SECONDS < secs )); do    # Loop until interval has elapsed.
        # ...
#     done
    sleep 3
    rm $IR
    echo "0" > /sys/class/gpio/gpio25/value
  fi

  # read inputs
#   DD="$(cat /sys/class/gpio/gpio26/value)"
  EE="$(cat /sys/class/gpio/gpio4/value)"
#   KK="$(cat /sys/class/gpio/gpio24/value)"

#   if [ "$KK" -eq "0" ]; then
#     touch $KILL
#   fi

  echo "$EE"

  if [ "$EE" -eq "0" ]; then

    touch $IR

  fi


 #  sleep .01;  no sleep for very fast loop
done

exit 0
