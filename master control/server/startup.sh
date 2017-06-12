#!/bin/bash
# gets update scripts
#
# Copyright (C) 2015 - 2016 Uvea I. S., Kevin Rattai
# BSD license https://raw.githubusercontent.com/krattai/AEBL/master/LICENSE
#
# This is the first script from clean bootup.

# FIRST_RUN_DONE="/home/pi/.firstrundone"
# AEBL_TEST="/home/pi/.aebltest"
# TEMP_DIR="/home/pi/tmp"
# 
# T_STO="/run/shm"
# T_SCR="/run/shm/scripts"

# LOCAL_SYS="${T_STO}/.local"

cd $HOME

# cp -p /home/pi/.scripts/* /run/shm/scripts

# $T_SCR/./run.sh &
scripts/./pub.sh &
sleep 60s
scripts/./clpi.py &
scripts/./c_assign.py &
scripts/./bridge_test.sh &

exit
