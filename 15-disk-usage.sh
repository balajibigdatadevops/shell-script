#!/bin/bash

DISK_USAGE=$(df -hT |grep -vE "tmp|File")
DISK_THRESHOLD=1
MESSAGE=""

while IFS= read -r LINE
do
  Usage=$(echo $LINE | awk '{print $6}'| cut -d "%" -f1)
  Partition=$(echo $LINE | awk '{print $1}')
  if [ $Usage -ge $DISK_THRESHOLD ]
    then 
     message+="High Disk Usage on $Partition: $Usage\n"
  fi     
done <<< $DISK_USAGE

echo -e "Messaage for Disk Usage"
echo -e "$message"

