#!/bin/bash
# Shell script to copy all files recursively and upload them to
# remote FTP server (copy local all directories/tree to remote ftp server)
#
# If you want to use this script in cron then make sure you have
# file pointed by $AUTHFILE (see below) and add lines to it:
# host ftp.mycorp.com
# user myftpuser
# pass mypassword
#
# This is a free shell script under GNU GPL version 2.0 or above
# Copyright (C) 2005 nixCraft
# Feedback/comment/suggestions : http://cyberciti.biz/fb/
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
 
FTP="/usr/bin/ncftpput"
CMD=""
AUTHFILE="/root/.myupload"
 
if [ -f $AUTHFILE ] ; then
  # use the file for auth
  CMD="$FTP -m -R -f $AUTHFILE $myf $remotedir $localdir"
else
  echo "*** To terminate at any point hit [ CTRL + C ] ***"
  read -p "Enter ftpserver name : " myf
  read -p "Enter ftp username : " myu
  read -s -p "Enter ftp password : " myp
  echo ""
  read -p "Enter ftp remote directory [/] : " remotedir
  read -p "Enter local directory to upload path [.] : " localdir
  [ "$remotedir" == "" ] && remotedir="/" || :
  [ "$localdir" == "" ] && localdir="." || :
  CMD="$FTP -m -R -u $myu -p $myp $myf $remotedir $localdir"
fi
 
$CMD
