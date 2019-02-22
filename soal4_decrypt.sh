#!/bin/bash

nama=$(date '+%H:%M %d-%m-%Y')
sif=$(date '+%H')

base=$(printf "%x" "'a")
keydec=`expr $base + $sif`
key=$(echo "$keydec" | echo $(xxd -p -r))
keydec1=`expr $keydec - 1`
key1=$(echo "$keydec1" | echo $(xxd -p -r))

baseup=$(printf "%x" "'A")
keyupdec=`expr $baseup + $sif`
keyup=$(echo "$keyupdec" | echo $(xxd -p -r))
keyupdec1=`expr $keyupdec - 1`
keyup1=$(echo "$keyupdec1" | echo $(xxd -p -r))

cat "$1" | tr [$key-za-$key1$keyup-ZA-$keyup1] [a-zA-Z] >> "$nama"_decrypted
