#!/bin/bash

echo "Negara dengan penjualan terbanyak pada tahun 2012 adalah"
negara=$(awk -F, '
  /2012/ {a[$1]+=$10}
  END{for(i in a) print i",",a[i]}
  ' WA_Sales_Products_2012-14.csv | sort -t $"," -n -k2 -r | awk -F, '{print $1}' | head -1)
echo "$negara"

printf "\n3 Product Line dengan penjualan terbanyak di $negara pada tahun 2012:\n"
awk -F, -v negara="$negara" '
  ($1~negara) && ($7 == 2012) {a[$4]+=$10}
  END{for(i in a) print i",",a[i]}
  ' WA_Sales_Products_2012-14.csv | sort -t $"," -n -k2 -r | head -3 | awk -F, '{print $1}'

printf "\n3 Product berdasarkan tiga Product Line pada soal b dengan penjualan terbanyak di $negara pada tahun 2012:\n"
produk1="Personal Accessories"
produk2="Camping Equipment"
produk3="Outdoor Protection"
awk -F, -v produk1="$produk1" -v negara="$negara" -v produk2="$produk2" -v produk3="$produk3" '
  ($1~negara) && (($4~produk1) || ($4~produk2) || ($4~produk3)) && ($7 == 2012) {a[$6]+=$10}
  END{for(i in a) print i",",a[i]}
  ' WA_Sales_Products_2012-14.csv | sort -t $"," -n -k2 -r | head -3 | awk -F, '{print $1}'
