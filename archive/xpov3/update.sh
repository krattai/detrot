#!/bin/bash
# runs updates
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai

date >> $HOME/logs/adsys.log
echo 'update script run' >> $HOME/logs/adsys.log

cd $HOME

wget -N -nd http://206.45.113.102/ftp/forclients/grabfiles.sh

cd $HOME

./grabfiles.sh

cd $HOME

wget -N -nd http://206.45.113.102/ftp/forclients/ihdnunzads.sh

cd $HOME

xset led 3

sleep 60

totem --quit &

wait

./ihdnunzads.sh

date >> $HOME/logs/adsys.log
echo 'getting playlist run' >> $HOME/logs/adsys.log

cd $HOME/Videos

wget -N -nd http://206.45.113.102/ftp/forclients/ihdn.ca.3.0.pls &

wait

cd $HOME

xset -led 3

sleep 60

date >> $HOME/logs/adsys.log
echo 'restarting totem' >> $HOME/logs/adsys.log

totem --fullscreen $HOME/Videos/ihdn.ca.3.0.pls 2>&1 | tee $HOME/logs/admov.log

date >> $HOME/logs/adsys.log
echo '      ' >> $HOME/logs/adsys.log
echo '~~~~~~~~~~~~~~~~~~~~~~~~~' >> $HOME/logs/adsys.log
echo '      ' >> $HOME/logs/adsys.log

# apt-get update

# reboot system

exit 0
