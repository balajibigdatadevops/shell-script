#!/bin/bash

SOURCE_DIR="/tmp/shellscript-logs"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="$0-$TIMESTAMP.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ ! -d $SOURCE_DIR ]
  then 
      echo -e "$G creating directory $SOURCE_DIR $N"
      mkdir -p /tmp/shellscript-logs 
  else
      echo -e "$Ydirectory $SOURCE_DIR exists $N"
fi

##creating old log files using touch -d command

for Old_log_file in $SOURCE_DIR
do
   touch -d 20231201 $Old_log_file/user.log  
   touch -d 20231208 $Old_log_file/shipping.log 
   touch -d 20231221 $Old_log_file/shipping.js 
   touch -d 20231204 $Old_log_file/user.js 
   touch $Old_log_file/latest_$(date +%F).log 
done

FILES_TO_DELETE=$(find $SOURCE_DIR  -type f  -name "*.log" -mtime +14)

while IFS= read -r LINE
do
  echo "started deleting old log files: on $TIMESTAMP $LINE" 
  rm -rf $LINE
  echo "completed deleting old files: on $TIMESTAMP $LINE"
done <<<  $FILES_TO_DELETE




