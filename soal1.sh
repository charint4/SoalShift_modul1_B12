#!/bin/bash

cd /home/Penunggu/sisop/Modul1/jawab/satu
unzip nature.zip

for file in "nature/"*
do
  base64 -d "$file" | xxd -r > $(basename "$file")
  echo "$file decrypted"
  mv $(basename "$file") nature
done
