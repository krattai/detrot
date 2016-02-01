#!/bin/bash
# gets update scripts
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai

# wget -N -nd http://ihdn.ca/ftp/demoads/update.sh -O $HOME/update.sh

xset led 3
sleep 1

xset -led 3
sleep 1

xset led 3
sleep 1

xset -led 3
sleep 1

xset led 3
sleep 1

xset -led 3
sleep 1

xset led 3
sleep 1

xset -led 3
sleep 1

xset led 3
sleep 1

xset -led 3
sleep 1

date >> $HOME/logs/adsys.log
echo 'get update script run' >> $HOME/logs/adsys.log

cd $HOME

wget -N -nd http://206.45.113.102/ftp/forclients/update.sh

cd $HOME
./update.sh

exit 0
