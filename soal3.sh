#!/bin/bash

i=1
pass=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)

while [ -f ./password"$i".txt  ]
do
  if [ "$pass" == "$(cat ./password"$i".txt)" ]
  then
    pass=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
    i=1
  else
    let "i++"
  fi
done

echo "$pass" >> password"$i".txt
