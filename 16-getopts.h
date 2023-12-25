#!/bin/bash

while getopts ":a:b:" opt;
  do
   case $opt in
   a)
   echo "Option 'a' with value $OPTARG"
   ;;
   b)
   echo "Option 'b' with value $OPTARG"
   ;;
   \?)
   echo "Invalid option:: $OPTARG"
   ;;
   :)
   echo "Option - $OPTARG requires an argument"
   ;;
   easc
  done
