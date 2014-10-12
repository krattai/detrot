#!/bin/bash
#
#
# Filename: tmpdir_maintenance.sh
#
# Copyright (c) 2010, B Tasker
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#  * Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
#
# A simple script to clear temporary files and 
# report it's status to the adminsitrator
#
#
# Utilises the BASH OAuth libraries from Yu-Jie Lin
# http://blog.yjl.im/2010/05/bash-oauth.html
#
# We want to report the following information to the SysAdmin
#
# Date/Time
# Number of Files in Temporary Directory
# Number of Files successfully removed
#
# As this is a simple example script, we're not going to 
# recurse into directories.


########### Variables ###################


# Where is the log file to write to?
LOGFILE="/home/pi/tmpdir_maintenance/tmpdir_maintenance.log"

# Where are your temporary files stored?
TEMP_DIRECTORY="/tmp"

# Where is this script?
PROG_ROOT="/home/pi/tmpdir_maintenance/"

########### Variables End ###############


# We want to be in the Temporary Directory
cd "$TEMP_DIRECTORY"


# Use ls to grab the file count
# Double space after -F\ 
FILE_COUNT=$( ls -l | grep total | awk -F\  '{print $2}')


# Take note of the number of directories
# For some reason ls doesn't display total when limited to directories
# So we need to count them
# 
# Again, note the double space after -F\ 
DIR_COUNT=$( ls -ld | wc -l | awk -F\  '{print $1}')

# Subtract the number of directories from the File Count
FILE_COUNT=$(( $FILECOUNT - $DIR_COUNT))

# Set our Date Stamp 
DATESTAMP=$( date +'%d%m%Y %H%M')

# We've not deleted anything yet, so lets zero our counters
DEL_COUNT="0"
FAILED_COUNT="0"

# We now have a file count. Begin deleting files one by one

for a in *;
do

# Check whether it's a directory

if [ -d "$a" ]
then

# It is so don't touch it, or the count
echo "Skipping Directory $a"

else

# It's not a Dir, try and delete it
rm -f "$a" 

# Check whether it worked

if [ "$?" == "0" ]
then
# Was successful
# Add one to the Del_Count
DEL_COUNT=$(( $DEL_COUNT + 1 ))

else
# Was Unsuccessful
# Add one to the failed count
FAILED_COUNT=$(( FAILED_COUNT + 1 ))

fi

fi

done


# We've now attempted to delete all files in TEMPDIR. So lets report our success;
#
# We need to ensure it doesn't exceed 140 characters or posting to Twitter will fail
# Note: HOSTNAME will display the DNS hostname of the system
STATUS_MESSAGE="$DATESTAMP $HOSTNAME $FILE_COUNT files in $TEMP_DIRECTORY. \
$DEL_COUNT Removed. $FAILED_COUNT Failed"

# Record the activity in a local log
/bin/cat << EOM >> "$LOGFILE"
$STATUS_MESSAGE
EOM

# Use the Twitter modules to post the information
cd "$PROG_ROOT"/mod_Twitter
./tcli.sh -c statuses -s "$STATUS_MESSAGE" > "$TEMP_DIRECTORY"/tmpdir_maintenance.$$.tmp

# Status should have posted to Twitter. Parse the response to check that it has;
cat "$TEMP_DIRECTORY"/tmpdir_maintenance.$$.tmp | grep \ > /dev/null

if [ "$?" == "1" ]
then 

# An error occurred
echo "An error occurred posting to Twitter" >> "$LOGFILE"

fi

# Tidy up
rm -f "$TEMP_DIRECTORY"/tmpdir_maintenance.$$.tmp

# Exit the script
echo "Saying Goodbye!"
exit
