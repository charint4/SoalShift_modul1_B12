#!/bin/bash

sif=$(echo "$1" | head -c 2)

if [ $sif == "00" ]
then
    cat "$1" >> "$1"_decrypted
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

cat "$1" | tr [$key-za-$key1$keyup-ZA-$keyup1] [a-zA-Z] >> "$1"_decrypted
