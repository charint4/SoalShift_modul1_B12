#!/bin/bash

nama=$(date '+%H:%M %d-%m-%Y')
sif=$(date '+%H')

if [ $sif == "00" ]
then
    cat /var/log/syslog >> "$nama"
    exit
fi

decbase=$(printf "%d" "'a")
keydec=`expr $decbase + $sif`
keyhex=$(bc <<<"obase=16;$keydec")
key=$(echo $keyhex | xxd -p -r)

keydec1=`expr $keydec - 1`
key1hex=$(bc <<<"obase=16;$keydec1")
key1=$(echo $key1hex | xxd -p -r)

decbaseup=$(printf "%d" "'A")
keyupdec=`expr $decbaseup + $sif`
keyuphex=$(bc <<<"obase=16;$keyupdec")
keyup=$(echo $keyuphex | xxd -p -r)

keydecup1=`expr $keyupdec - 1`
keyup1hex=$(bc <<<"obase=16;$keydecup1")
keyup1=$(echo $keyup1hex | xxd -p -r)

cat /var/log/syslog | tr [a-zA-Z] [$key-za-$key1$keyup-ZA-$keyup1] >> "$nama"
