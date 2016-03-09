#!/bin/bash
#
# 
# Dec 2015 Larry
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
sudo /home/pi/bin/det_28.sh

# sudo /home/pi/scripts/det_7.sh  
exit 0
