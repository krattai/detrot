#!/bin/bash
# start totem script
#
# To be used at boot time or other times when totem needs to be started in order to ensure
# that totem log file is created and updated accordingly.
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai

# wget -N -nd http://ihdn.ca/ftp/demoads/update.sh -O $HOME/update.sh

date >> $HOME/logs/adsys.log
echo 'starting totem' >> $HOME/logs/adsys.log

cd $HOME

totem --fullscreen $HOME/demo/ihdn.ca.3.0.pls 2>&1 | tee $HOME/logs/admov.log


exit 0
