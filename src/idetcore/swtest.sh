#!/bin/bash
#
# Copyright (C) 2014 - 2016 IHDN, Uvea I. S., Kevin Rattai
#
# 16/03/28 - Kevin Rattai
# added playlist feature
#
# need to look at way to possibly watch for constant non-signal in order to
# put device into a "sleep" mode and not play commercials if source is turned off
#
# 10/07/7 - Kevin Rattai
# added IR code
#
# 10/07/11 - Kevin Rattai
# added kill switch code
#
# ----------------
# det_28.sh  10 second sleep time for testing
# Dec 29 2015 Larry
# Mar 24 2016 Kevin
#   + add proper playlist function from idet0091 source
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

# Added code to create detector playlists
# might want to export this code to seperate script once this works
# If you want to switch omxplayer to something else, or add parameters, use these
PLAYER="omxplayer"
PLAYER_OPTIONS="-o hdmi -r"
# additional constants
T_STO="/run/shm"
T_SCR="/run/shm/scripts"
PLAYLIST="${T_STO}/.detpl"
PLAYLIST_FILE="${T_STO}/.playlist"
NEW_PL="${T_STO}/.newpl"

OUT="/home/pi/.out"
SHORT="/home/pi/.short"
KILL="${T_STO}/.kill"

# create playlist if not exist, which it should not on boot and start det.sh
if [ ! -f "${PLAYLIST_FILE}" ] && [ ! -f "${NEW_PL}" ]; then
    sudo -u pi $T_SCR/./playlist.sh /home/pi/ad/*.mp4
    sudo -u pi cp "${PLAYLIST_FILE}" "${NEW_PL}"
fi

# Get the top of the playlist
#  making assumption that the playlist has at least one file in it
file=$(cat "${PLAYLIST_FILE}" | head -n1)

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

# *********************************************

# Boot for HDMI switch


HH="$(cat /sys/class/gpio/gpio22/value)" # chnl 2 led must be 1 to be net
      if [ "$HH" -eq "0" ]; then
         echo "0" > /sys/class/gpio/gpio17/value
         sleep .2  
         echo "1" > /sys/class/gpio/gpio17/value
      fi

sleep .5


# *********************************************

sudo setterm -blank 1


sleep 2
   # would be sent token if spin seperate program
   # touch /home/pi/.ready
   # if ready set LED green
echo "0" > /sys/class/gpio/gpio5/value #red off
echo "1" > /sys/class/gpio/gpio6/value #green on
g1=1


# Start Loop Program ****************************
while :
do
  # nb:  kill should turn off all LEDs on back panel, except green pwr
  #      also, kill should place unit into test mode - refer to Larry's notes
  #      - turn all LEDs off except red LED on front
  #      - green power button will remain as light green
  if [ -f "${KILL}" ]; then
    echo "1" > /sys/class/gpio/gpio25/value
    hostn=$(cat /etc/hostname)
    mosquitto_pub -d -t ihdn/alladin/log -m "$(date) : $hostn kill triggered." -h "ihdn.ca" &
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
    sleep 10
    rm $KILL
    echo "0" > /sys/class/gpio/gpio25/value
  fi

  # read inputs
  DD="$(cat /sys/class/gpio/gpio26/value)"
  EE="$(cat /sys/class/gpio/gpio4/value)"
  KK="$(cat /sys/class/gpio/gpio24/value)"

  if [ "$KK" -eq "0" ]; then
    touch $KILL
  fi

  echo "$EE"

  if [ "$EE" -eq "0" ]; then

    echo "1" > /sys/class/gpio/gpio25/value
    echo "IR triggered"
#     mosquitto_pub -d -t ihdn/alladin/log -m "$(date) : $hostn IR clear." -h "ihdn.ca"    echo "0" > /sys/class/gpio/gpio25/value
    echo "0" > /sys/class/gpio/gpio25/value

#   else

#     echo "IR clear"
#     mosquitto_pub -d -t ihdn/alladin/log -m "$(date) : $hostn IR clear." -h "ihdn.ca"

  fi


 #  sleep .01;  no sleep for very fast loop
done

exit 0

















# Notes for scripting *********************
  # Setup GPIO 17, set to output, and send 0

  #      echo "17" > /sys/class/gpio/export
  #      echo "out" > /sys/class/gpio/gpio17/direction
  #      echo "0" > /sys/class/gpio/gpio17/value

  #      # Setup GP

