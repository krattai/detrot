#!/bin/bash
#
# Copyright (C) 2014 - 2016 IHDN, Uvea I. S., Kevin Rattai
#
# 16/03/28 - Kevin Rattai
# added playlist feature
# ----------------
# det_28.sh  10 second sleep time for testing
# Dec 29 2015 Larry
# Mar 24 2016 Kevin
#   + add proper playlist function from idet0091 source
#
# Variables *****
#  DD = detect input
#  EE = eye input
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
    # Start playback; could NOHUP this instead of &
    #  was:  omxplayer /home/pi/ad/*.mp4 &

    # If not out, switch then play, if out play then switch
    if [ ! -f "${OUT}" ]; then
      # switch relay and go Amber
      echo "1" > /sys/class/gpio/gpio5/value 
      echo "0" > /sys/class/gpio/gpio17/value
      sleep .2  
      echo "1" > /sys/class/gpio/gpio17/value
         
      "${PLAYER}" ${PLAYER_OPTIONS} "${file}" > /dev/null

    else
      "${PLAYER}" ${PLAYER_OPTIONS} "${file}" > /dev/null &
         
      # omxplayer -o hdmi -r /home/pi/ad/*.mp4
      # switch relay and go Amber
      echo "1" > /sys/class/gpio/gpio5/value 
      echo "0" > /sys/class/gpio/gpio17/value
      sleep .2  
      echo "1" > /sys/class/gpio/gpio17/value
    fi
   
    if [ -f "${OUT}" ]; then
      # To prevent false trigger, wait 7 sec before out check
      sleep 7

      # This loop SHOULD find next gpio SIG or mp4 EOF, this will ONLY
      #  work in "demo" while production will need different tests
      #  and this assumes that gpio2 only goes off for millisecs then
      #  back on, otherwise this check doesn't work properly
      #
      # ie. gpio should be stream, for better realtime monitoring

      DD="$(cat /sys/class/gpio/gpio26/value)"
      while [ ! "$DD" = "1" ] && [ "$(pgrep omxplayer.bin)" ]; do
        # read inputs
        DD="$(cat /sys/class/gpio/gpio26/value)"
      done
    fi

    # trigger occured, begin switch, kill and reset

    # VERY FIRST THING! -> switch back
    # switch back
    echo "0" > /sys/class/gpio/gpio17/value
    sleep .2  
    echo "1" > /sys/class/gpio/gpio17/value
        
    # go red sleep
    echo "0" > /sys/class/gpio/gpio6/value

    # kill if omxplayer still running
    if [ "$(pgrep omxplayer.bin)" ]; then
      # not finished playing, kill and do not log
      kill $(pgrep omxplayer.bin)
    else
      # log video played
      NUMBER=`/bin/date +"%Y-%m-%d-%H-%M-%S"`
      echo "$file...$NUMBER" >> /home/pi/logs/playlog.txt 

      hostn=$(cat /etc/hostname)
      # ext_ip4=$(dig +short myip.opendns.com @resolver1.opendns.com)
      # ext_ip6=$(curl icanhazip.com)
      mosquitto_pub -d -t ihdn/plog -m "$(date) : $hostn played ${file}." -h "ihdn.ca"


      # pop current playing file off the playlist file
      cat "${PLAYLIST_FILE}" | tail -n+2 > "${PLAYLIST_FILE}.new"
      chown pi:pi "${PLAYLIST_FILE}.new"
      sudo -u pi mv "${PLAYLIST_FILE}.new" "${PLAYLIST_FILE}"

      # Get the top of the playlist
      file=$(cat "${PLAYLIST_FILE}" | head -n1)
      # If file empty, playlist must be empty, so recreate
      if [ -z "${file}" ]; then
        rm "${PLAYLIST_FILE}"

        # make sure only playlist files in ad folder
        sudo -u pi mv /home/pi/ad/*.mp4 /home/pi/mp4
        sudo -u pi cp "${NEW_PL}" "${T_STO}/swp"
        MV_FILE="${T_STO}/swp"
        x=1
        while [ $x == 1 ]; do
          # check file doesn't exist
          if [ ! -f "${MV_FILE}" ]; then
            echo "Playlist file ${MV_FILE} not found"
            exit 1
          fi
          # Get the top of the mv list
          cont=$(cat "${MV_FILE}" | head -n1 | sed 's/.*\///')
          # Skip if this is empty
          if [ -z "${cont}" ]; then
            echo "Move file empty or bumped"
            x=0
          else
            # And strip it off the move file
            cat "${MV_FILE}" | tail -n+2 > "${MV_FILE}.new"
            chown pi:pi "${MV_FILE}.new"
            sudo -u pi mv "${MV_FILE}.new" "${MV_FILE}"
            # Move file to ad folder
            sudo -u pi mv "/home/pi/mp4/${cont}" "/home/pi/ad"
          fi
        done
        rm "${T_STO}/swp"

        sudo -u pi cp "${NEW_PL}" "${PLAYLIST_FILE}"
        file=$(cat "${PLAYLIST_FILE}" | head -n1)
      fi

    fi    
    # start 30s sleep, was: start 270 second sleep
    # NB: if blip during this wait, then "in" and should not play
    #      on next blip, so this COULD fail during game, if next ad
    #      within 270 therefore, should do check how many blips or
    #      should only wait for 10 seconds or so

    if [ -f "${SHORT}" ]; then
      wait=30
    else
      wait=210
    fi

    while [ $cc -le $wait ]; do
      cc=$(( $cc + 1 ))
      sleep 1
    done
    cc=0

    # If there is a new set of ads, update for next rotation
    if [ -f "/run/shm/.newplay" ]; then
      rm /run/shm/.newplay
#           sudo -u pi mv "${PLAYLIST_FILE}" "${PLAYLIST_FILE}.cur"
#           sudo -u pi $T_SCR/./playlist.sh /home/pi/ad/*.mp4
#           rm "${NEW_PL}"
#           sudo -u pi mv "${PLAYLIST_FILE}" "${NEW_PL}"
#           sudo -u pi mv "${PLAYLIST_FILE}.cur" "${PLAYLIST_FILE}"
    fi

    # Go back green ready reset cc
    echo "0" > /sys/class/gpio/gpio5/value
    echo "1" > /sys/class/gpio/gpio6/value
  fi

  # If new playlist, then update playlist, since mkplay.sh not running
  #  uses ad directory for playlist compilation
  #  eventually should use the mp4 directory, like other AEBL products, maybe
  if [ ! -f "${T_STO}/mkpl" ] && [ -f "${T_STO}/mynew.pl" ]; then

    touch $T_STO/mkpl

    sudo -u pi cp "${T_STO}/mynew.pl" "${T_STO}/pl.part"

    PL_FILE="${T_STO}/pl.part"

    if [ -f "${T_STO}/pl.new" ]; then
      rm $T_STO/pl.new
    fi

    sudo -u pi touch $T_STO/pl.new

    PLAY_LIST="${T_STO}/pl.new"

    x=1

    while [ $x == 1 ]; do

      # check file doesn't exist
      if [ ! -f "${PL_FILE}" ]; then
        echo "Playlist file ${PL_FILE} not found"
        rm $T_STO/mkpl
        exit 1
      fi
    
      # Get the top of the playlist
      cont=$(cat "${PL_FILE}" | head -n1)
  
      # Skip if this is empty
      if [ -z "${cont}" ]; then
        echo "Playlist empty or bumped into an empty entry for some reason"

        x=0

      else
        # And strip it off the playlist file
        cat "${PL_FILE}" | tail -n+2 > "${PL_FILE}.new"
        chown pi:pi "${PL_FILE}.new"
        sudo -u pi mv "${PL_FILE}.new" "${PL_FILE}"

        # Append file to playlist
        echo "/home/pi/ad/${cont}" >> "${PLAY_LIST}"
      fi

    done

    rm $T_STO/mkpl

    if [ ! -f "${T_STO}/pl.tmp" ]; then
      sudo -u pi cp "${T_STO}/.newpl" "${T_STO}/pl.tmp"
    fi

    if [ -f "${T_STO}/.newpl" ]; then
      rm "${T_STO}/.newpl"
    fi

    chown pi:pi "${T_STO}/pl.new"
    sudo -u pi cp "${T_STO}/pl.new" "${T_STO}/.newpl"
    rm "${T_STO}/pl.new"
    rm "${T_STO}/mynew.pl"

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

