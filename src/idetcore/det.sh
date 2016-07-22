#!/bin/bash
#
# Copyright (C) 2014 - 2016 IHDN, Uvea I. S., Kevin Rattai, Larry Schultz
# 
# Dec 2015 Larry
# 
# 2016-07-22
# Kevin
# Added call to start new IR detector
#
# Fix screen saver
sudo setterm -blank 1
# 
# Log boot time not needed cause cron works.....
# .....sudo /home/pi/bin/pi_logboot.sh &
#

# sudo /home/pi/bin/det_25.sh

# sudo /home/pi/bin/eye_2.sh &
# sleep 2

# start det_irk.sh
sudo /home/pi/bin/det_irk.sh &

# Wait 5 seconds to ensure IR det ready
sleep 5

# start det_28.sh
sudo /home/pi/bin/det_28.sh &

# sudo /home/pi/scripts/det_7.sh  
exit 0
