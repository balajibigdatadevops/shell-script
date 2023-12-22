#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started at exeucint $TIMESTAMP" &>> $LOGFILE

VALIDATE() 
 {
 if [ $1 -ne 0 ]
  then
    echo -e "$2 ... $R FAILED $N"
  else
    echo -e "$2 ... $G SUCCESS $N"
 fi
 }

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

#echo "All arguments are passed: $@"

for each_package in $@
   do
     yum list installed $each_package &>> $LOGFILE
     if [ $? -ne 0 ]
     then 
         yum install $each_package -y &>> $LOGFILE
         VALIDATE $? "Installation of $each_package"
    else
       echo -e "$package already installed  ... $Y skipping $N"
    fi
done




