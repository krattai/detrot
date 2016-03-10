#!/bin/bash
#
# det_28.sh  10 second sleep time for testing
# Dec 29 2015 Larry
#
# Variables *****
#  DD = detect input
#  EE = eye input
#  g1 = Green LED default is power led with pi.
#  r1 = Red LED indicate sleep mode
#  r2 = Relay output
#  cc = sleep counter

# Set Variable Defaults *****
DD=0
EE=1
HH=0
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
      # read inputs
   DD="$(cat /sys/class/gpio/gpio26/value)"
   
      # Check if ready and Detect pulse
      if [ "$DD" -eq "1" ]; then
         # switch relay and go Amber
         echo "1" > /sys/class/gpio/gpio5/value 
         echo "0" > /sys/class/gpio/gpio17/value
         sleep .2  
         echo "1" > /sys/class/gpio/gpio17/value
         
         
         omxplayer -o hdmi -r /home/pi/ad/*.mp4
   
         # switch back
            echo "0" > /sys/class/gpio/gpio17/value
            sleep .2  
            echo "1" > /sys/class/gpio/gpio17/value
         
         
         
         # go red sleep
         echo "0" > /sys/class/gpio/gpio6/value
         # log video played
         NUMBER=`/bin/date +"%Y-%m-%d-%H-%M-%S"`
         echo "facepaint...$NUMBER" >> /home/pi/logs/playlog.txt 
            while [ $cc -le 270 ]; do #270 or 15 for short sleep
               cc=$(( $cc + 1 ))
               sleep 1
            done
             # Go back green ready reset cc
          echo "0" > /sys/class/gpio/gpio5/value
          echo "1" > /sys/class/gpio/gpio6/value
          cc=0
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
