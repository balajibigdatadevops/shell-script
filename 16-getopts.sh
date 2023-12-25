#!/bin/bash

while getopts ":a:b:" opt;
  do
   case $opt in
   a)
   echo "Option 'a' with value $TEST"
   ;;
   b)
   echo "Option 'b' with value $TEST"
   ;;
   \?)
   echo "Invalid option:: $TEST"
   ;;
   :)
   echo "Option - $TEST requires an argument"
   ;;
   esac
  done
