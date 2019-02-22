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

produk1="Personal Accessories"
printf "\n3 Product dengan penjualan terbanyak dari Product Line Personal Accessories\n"
awk -F, -v produk1="$produk1" -v negara="$negara" '
  ($1~negara) && ($4~produk1) && ($7 == 2012) {a[$6]+=$10}
  END{for(i in a) print i",",a[i]}
  ' WA_Sales_Products_2012-14.csv | sort -t $"," -n -k2 -r | head -3 | awk -F, '{print $1}'

produk2="Camping Equipment"
printf "\n3 Product dengan penjualan terbanyak dari Product Line Camping Equipment\n"
awk -F, -v produk2="$produk2" -v negara="$negara" '
  ($1~negara) && ($4~produk2) && ($7 == 2012) {a[$6]+=$10}
  END{for(i in a) print i",",a[i]}
  ' WA_Sales_Products_2012-14.csv | sort -t $"," -n -k2 -r | head -3 | awk -F, '{print $1}'

produk3="Outdoor Protection"
printf "\n3 Product dengan penjualan terbanyak dari Product Line Outdoor Protection\n"
awk -F, -v produk3="$produk3" -v negara="$negara" '
  ($1~negara) && ($4~produk3) && ($7 == 2012) {a[$6]+=$10}
  END{for(i in a) print i",",a[i]}
  ' WA_Sales_Products_2012-14.csv | sort -t $"," -n -k2 -r | head -3 | awk -F, '{print $1}'


