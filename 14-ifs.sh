#!/bin/bash

file="/etc/passwd"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


if [ ! -f $file ]
then 
   echo -e "$R file:: $file does not exists $N"
else
   echo -e "$Y file: $file does exists and displaying $file content $N"
fi

while IFS=":" read -r username password user_id group_id user_fullname user_homedir user_shell_path
  do
   echo -e  "user name is: $Y $username $N"
   echo -e  "password is: $Y $password $N"
   echo -e  "user_id is: $Y $user_id $N"
   echo -e "group_id is:$Y $group_id $N"
   echo -e "user_fullname is:$Y $user_fullname $N"
   echo -e "user_fullname is:$Y $user_fullname $N"
   echo -e "user_homedir is:$Y $user_homedir $N"
   echo -e "user_shell_path is: $Y $user_shell_path $N"
done <$file

