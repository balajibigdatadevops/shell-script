#!/bin/bash

NUMBER1=$1
NUMBER2=$2

if [ $# -ne 2 ]
then 
    echo "pease execute script by following below usage:"
    echo "Usage: <script name> <arg1> <arg2>"
    exit 1
else 
    echo "please run the script by passing command line args arg1 arg2"
fi

SUM=$(($NUMBER1+$NUMBER2))

echo "Total:: $SUM"

echo "How many args passed:: $#"

echo "All args passed:: $@"

echo "Script name:: $0"