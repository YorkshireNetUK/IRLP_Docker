#!/bin/bash

sleep 1
echo -n "Changing Present Working Directory PWD to home"
cd /home/thelinkbox
echo "Done!"


sleep 1
echo -n "Update the timezone to central time... "
sleep 1
TZ='America/Chicago'; export TZ
echo "Done!"
sleep 1
echo -n "here is the current time and date"

date

sleep 1
echo -n "Starting up the Link Box "
/usr/local/libexec/tlb -d -f tlb.conf  >&/dev/null 2>&1 &
echo "Done!"

sleep 1

echo -n "this is the end of this script - - - " 

sleep 1 

echo " good bye." 

exit
