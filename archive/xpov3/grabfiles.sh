#!/bin/bash
# Shell script to grab video files off server
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai
 
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_01_1.VOB -O $HOME/demo/VTS_01_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_02_1.VOB -O $HOME/demo/VTS_02_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_03_1.VOB -O $HOME/demo/VTS_03_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_04_1.VOB -O $HOME/demo/VTS_04_1.VOB
# tput clear
# exit 0

date >> $HOME/logs/adsys.log
echo 'start grabfiles script run' >> $HOME/logs/adsys.log

cd $HOME/Videos

wget -N -nd http://206.45.113.102/ftp/forclients/testad01.7z
wget -N -nd http://206.45.113.102/ftp/forclients/testad02.7z
wget -N -nd http://206.45.113.102/ftp/forclients/testad03.7z
wget -N -nd http://206.45.113.102/ftp/forclients/testad04.7z
wget -N -nd http://206.45.113.102/ftp/forclients/0912230000.7z
wget -N -nd http://206.45.113.102/ftp/forclients/0912230001.7z
wget -N -nd http://206.45.113.102/ftp/forclients/0912230002.7z
wget -N -nd http://206.45.113.102/ftp/forclients/0912230003.7z
wget -N -nd http://206.45.113.102/ftp/forclients/0912230004.7z
wget -N -nd http://206.45.113.102/ftp/forclients/0912230005.7z
wget -N -nd http://206.45.113.102/ftp/forclients/0912230006.7z
wget -N -nd http://206.45.113.102/ftp/forclients/0912230007.7z
wget -N -nd http://206.45.113.102/ftp/forclients/0912230008.7z
wget -N -nd http://206.45.113.102/ftp/forclients/0912230009.7z
wget -N -nd http://206.45.113.102/ftp/forclients/0912230010.7z
wget -N -nd http://206.45.113.102/ftp/forclients/0912230011.7z

date >> $HOME/logs/adsys.log
echo 'end grabfiles script run' >> $HOME/logs/adsys.log

# tput clear
exit 0
