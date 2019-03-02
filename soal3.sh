#!/bin/bash

genpass() {
    pass=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
}

i=1
genpass

if [[ $pass =~ [A-Z] ]]
then
    if [[ $pass =~ [a-z] ]]
    then
        if [[ $pass =~ [0-9] ]]
        then
        else
            genpass
        fi
    else
        genpass
    fi
else
    genpass
fi

jml=0
for files in password*.txt
do
    let "jml++"
done
iter=$jml

while [ $iter -gt 0 ]
do
  if [ "$pass" == "$(cat ./password"$iter".txt)" ]
  then
    genpass
    iter=$jml
  else
    let "iter--"
  fi
done

while [ -f ./password"$i".txt ]
do
    let "i++"
done

echo "$pass" >> password"$i".txt
