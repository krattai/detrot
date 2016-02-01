#!/bin/bash
# Shell script to grab video files off server
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai
 
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_01_1.VOB -O $HOME/demo/VTS_01_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_02_1.VOB -O $HOME/demo/VTS_02_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_03_1.VOB -O $HOME/demo/VTS_03_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_04_1.VOB -O $HOME/demo/VTS_04_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_05_1.VOB -O $HOME/demo/VTS_05_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_06_1.VOB -O $HOME/demo/VTS_06_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_07_1.VOB -O $HOME/demo/VTS_07_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_08_1.VOB -O $HOME/demo/VTS_08_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_09_1.VOB -O $HOME/demo/VTS_09_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_10_1.VOB -O $HOME/demo/VTS_10_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_11_1.VOB -O $HOME/demo/VTS_11_1.VOB
# wget -N -nd http://ihdn.ca/ftp/demoads/VTS_12_1.VOB -O $HOME/demo/VTS_12_1.VOB
# tput clear
# exit 0

date >> $HOME/logs/adsys.log
echo 'start grabfiles script run' >> $HOME/logs/adsys.log

cd $HOME/demo

wget -N -nd http://206.45.113.102/ftp/forclients/testad01.7z
wget -N -nd http://206.45.113.102/ftp/forclients/testad02.7z
wget -N -nd http://206.45.113.102/ftp/forclients/testad03.7z
wget -N -nd http://206.45.113.102/ftp/forclients/testad04.7z

date >> $HOME/logs/adsys.log
echo 'end grabfiles script run' >> $HOME/logs/adsys.log

# tput clear
exit 0
