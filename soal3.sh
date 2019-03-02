#!/bin/bash

genpass() {
    pass=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
}

i=1
genpass

if [[ $pass =~ [A-Z] ]]
then
    echo "Besar dah ada"
    if [[ $pass =~ [a-z] ]]
    then
        echo "Kecil dah ada"
        if [[ $pass =~ [0-9] ]]
        then
            echo "Angka dah ada"
        else
            genpass
        fi
    else
        genpass
    fi
else
    genpass
fi

while [ -f ./password"$i".txt ]
do
  if [ "$pass" == "$(cat ./password"$i".txt)" ]
  then
    genpass
    i=1
  else
    let "i++"
    j=`expr $i+1`
    while [ -f ./password"$j".txt ]
    do
      if [ "$pass" == "$(cat ./password"$j".txt)" ]
      then
        i=1
        break
      else
        let "j++"
      fi
    done
  fi
done

echo "$pass" >> password"$i".txt

