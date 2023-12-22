#!/bin/bash

NUMBER=$1

if [ $# -ne 1 ]
then 
    echo "please execute script by following below usage:"
    echo "Usage: <script name> <arg1>"
    exit 1
else 
    echo "please run the script by passing command line args arg1 arg2"
fi

if [ $NUMBER -gt 100 ]
then
   echo "Give number $NUMBER is greater than 100"
else
   echo "Give number $NUMBER is not greater than 100"
fi