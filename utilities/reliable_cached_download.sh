#!/bin/sh
#Reliably download the URL given as argument with Wget

if [ -e $2 ]
then
   echo "File already downloaded"
else
  wget --retry-connrefused --read-timeout=30 -O $2 $1
fi

