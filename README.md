# SoalShift_modul1_B12

### Outline
+ [Perintah 1](#perintah-1)
    + [Basic Commands](#penyelesaian)
    + [Full Code](#full-code)
    + [Cronjob Soal1](#cronjob-soal1)
+ [Perintah 2](#perintah-2)
    + [2.a](#a)
    + [2.b](#b)
    + [2.c](#c)
+ [Perintah 3](#perintah-3)
    + [Kodingan ini](#kodingan-ini)

### Soal 1
Anda diminta tolong oleh teman anda untuk mengembalikan filenya yang telah
dienkripsi oleh seseorang menggunakan bash script, file yang dimaksud adalah
nature.zip. Karena terlalu mudah kalian memberikan syarat akan membuka seluruh
file tersebut jika pukul 14:14 pada tanggal 14 Februari atau hari tersebut adalah hari
jumat pada bulan Februari.
Hint: Base64, Hexdump

#### Penyelesaian:

Pertama-tama unzip isi dari nature.zip dengan perintah
```
unzip nature.zip
```
Setelah itu di akan muncul file-file `.jpg` yang tidak bisa dibuka (karena terenkripsi). Untuk mendekripsinya, gunakan perintah
```
base64 -d nama_file_input >> nama_file_output
```
+ base64 adalah perintah yang digunakan untuk mengenkripsi/mendekripsi data.
+ -d adalah argumen dari perintah base64 yang tujuannya agar perintah tersebut melakukan __dekripsi__.
Setelah itu, akan muncul file hasil dekripsinya. Tetapi bila dibuka, file itu masih dalam bentuk _hexdump_. Untuk melihat file tersebut dalam bentuk yang dapat dipahami manusia, gunakan perintah
```
xxd -r nama_file_input >> nama_file_output
```
+ xxd adalah perintah yang digunakan untuk membuat hexdump atau mengembalikan hexdump ke bentuk semula
+ -r adalah argumen dari perintah xxd yang tujuannya agar perintah tersebut mengembalikan file input ke bentuk semula.
Untuk memudahkan kita agar tidak perlu membuat suatu file output temporer, maka gunakan _pipe_ ( | ) agar output dari suatu perintah akan menjadi input untuk perintah yang dituliskan setelah tanda _pipe_. Maka dua perintah di atas akan menjadi
```
base64 -d nama_file_input | xxd -r > nama_file_output
```
Cara di atas adalah untuk mendekripsi satu buah file. Untuk mendekripsi seluruh isi directory _nature_, gunakan _script_ di bawah ini
##### [Full Code](soal1.sh):
```
#!/bin/bash
unzip nature.zip

for file in "nature/"*
do
  base64 -d "$file" | xxd -r > $(basename "$file")
  echo "$file decrypted"
  mv $(basename "$file") nature
done
```
+ `#!/bin/bash` untuk memberitahu sistem bahwa perintah-perintah berikutnya harus dijalankan oleh Bash
+ `unzip nature.zip` meng-unzip file _nature.zip_
+ `for file in "nature/"*` untuk setiap file (nama variabel) di directory nature
+ `do` lakukan
+ `base64 -d "$file" | xxd -r > $(basename "$file")` dekripsi file, output-nya akan berada di directory tempat script berada. $file adalah variabel yang berisi nama file pada iterasi tersebut. Nilainya adalah "nature/nama_file".
Perintah `basename "$file"` digunakan untuk mendapatkan nama file-nya saja tanda path directory-nya. Output dari perintah tersebut adalah "nama_file" dari "nature/nama_file".
$(basename "$file") maksudnya sama seperti _\`basename "$file"\`_
+ `echo "$file decrypted"` output text ke terminal saat file sudah terdekripsi
+ `mv $(basename "$file") nature` memindahkan file yang sudah terdekripsi ke dalam directory nature sehingga me-replace file di dalam directory nature yang masih terenkripsi
+ `done` penutup dari perintah `do`

##### [Cronjob Soal1](cronjob.sh) :
```
14 14 14 2 5 /bin/bash /home/Penunggu/sisop/Modul1/jawab/satu/decryptor.sh
```
+ `14 14 14 2 5` maksudnya script yang dipilih akan dijalankan _“At 14:14 on day-of-month 14 and on Friday in February.”_ (by [crontab.guru](https://crontab.guru/#14_14_14_2_5))
+ `/bin/bash` untuk memberitahu agar script yang dipilih dijalankan menggunakan bash
+ `/home/Penunggu/sisop/Modul1/jawab/satu/decryptor.sh` path tempat script yang ingin dipakai berada


### Soal 2
Anda merupakan pegawai magang pada sebuah perusahaan retail, dan anda diminta
untuk memberikan laporan berdasarkan file WA_Sales_Products_2012-14.csv.
Laporan yang diminta berupa:

a. Tentukan negara dengan penjualan(quantity) terbanyak pada tahun
2012.
b. Tentukan tiga product line yang memberikan penjualan(quantity)
terbanyak pada soal poin a.
c. Tentukan tiga product yang memberikan penjualan(quantity)
terbanyak berdasarkan tiga product line yang didapatkan pada soal
poin b.

#### Penyelesaian:
#### a.
Gunakan `awk`. Syntax yang akan digunakan adalah
```
awk -F, '/2012/ {a[$1]+=$10} END{for(i in a) print i",",a[i]}' WA_Sales_Products_2012-14.csv | sort -t $"," -n -k2 -r | awk -F, '{print $1}' | head -1
```
+ `-F,` adalah argumen untuk memberitahu awk bahwa pembatas tiap kolom dari data yang kita miliki adalah koma (,)
+ `/2012/` mencari record yang memiliki string tersebut
+ `{a[$1]+=$10}` menjumlahkan quantity (pada kolom ke-10) dari array 'a' yang memiliki 'index'/nama yang sama.
+ `END{for(i in a) print i",",a[i]}` melakukan loop sebanyak 'index' array 'a' dan mencetak 'index' (yang berisi nama-nama negara) dan isi dari 'index' tersebut (kuantitas tiap negara penjualan)
+ `WA_Sales_Products_2012-14.csv` nama file yang dijadikan input
+ `sort -t $"," -n -k2 -r` mengurutkan output dari perintah sebelumnnya dengan ketentuan,
     + `-t $","` pembatas tiap kolom adalah koma (,)
     + `-n` mengurutkan berdasarkan nilai numerik
     + `-k2` dari kolom ke-2
     + `-r` untuk me-reverse hasil pengurutan (dari ascending menjadi descending)
+ `awk -F, '{print $1}'` mencetak kolom pertama dari hasil perintah sebelumnya
+ `head -1` mencetak record urutan teratas dari hasil perintah sebelumnya

#### b.
Masih pakai `awk` dan memanfaatkan output dari perintah bagian a. 
```
awk -F, -v negara="$negara" '($1~negara) && ($7 == 2012) {a[$4]+=$10} END{for(i in a) print i",",a[i]}' WA_Sales_Products_2012-14.csv | sort -t $"," -n -k2 -r | head -3 | awk -F, '{print $1}'
```
+ `-v negara="$negara"` membuat variable _negara_ yang berisi $negara (variabel yang menyimpan output dari bagian a)
+ `($1~negara)` memeriksa apakah dalam record-record di kolom 1 terdapat string yang terkandung dalam variabel _negara_
+  `&&` meng-AND-kan syarat pencarian
+ `($7 == 2012)` memeriksa apakah dalam record-record di kolom 7 terdapat record yang bernilai 2012
+ `END{for(i in a) print i",",a[i]}' WA_Sales_Products_2012-14.csv | sort -t $"," -n -k2 -r | head -3 | awk -F, '{print $1}'` kurang lebih sama seperti sebelumnya, hanya berbeda pada `head -3` yang berarti record yang dicetak adalah 3 record teratas.

#### c.
Untuk bagian c ini saya memilih untuk melakukan _hard coding_. Berikut syntax kodenya untuk ketiga hasil
```
produk1="Personal Accessories"
awk -F, -v produk1="$produk1" -v negara="$negara" ' ($1~negara) && ($4~produk1) && ($7 == 2012) {a[$6]+=$10} END{for(i in a) print i",",a[i]}' WA_Sales_Products_2012-14.csv | sort -t $"," -n -k2 -r | head -3 | awk -F, '{print $1}'

produk2="Camping Equipment"
awk -F, -v produk2="$produk2" -v negara="$negara" ' ($1~negara) && ($4~produk2) && ($7 == 2012) {a[$6]+=$10} END{for(i in a) print i",",a[i]}' WA_Sales_Products_2012-14.csv | sort -t $"," -n -k2 -r | head -3 | awk -F, '{print $1}'

produk3="Outdoor Protection"
awk -F, -v produk3="$produk3" -v negara="$negara" ' ($1~negara) && ($4~produk3) && ($7 == 2012) {a[$6]+=$10} END{for(i in a) print i",",a[i]}' WA_Sales_Products_2012-14.csv | sort -t $"," -n -k2 -r | head -3 | awk -F, '{print $1}'
```
Tidak beda jauh dengan sebelum-sebelumnya, hanya data yang diambil berbeda.

### Perintah 3
Buatlah sebuah script bash yang dapat menghasilkan password secara acak
sebanyak 12 karakter yang terdapat huruf besar, huruf kecil, dan angka. Password
acak tersebut disimpan pada file berekstensi .txt dengan ketentuan pemberian nama
sebagai berikut:

a. Jika tidak ditemukan file password1.txt maka password acak tersebut
disimpan pada file bernama password1.txt

b. Jika file password1.txt sudah ada maka password acak baru akan
disimpan pada file bernama password2.txt dan begitu seterusnya.

c. Urutan nama file tidak boleh ada yang terlewatkan meski filenya
dihapus.

d. Password yang dihasilkan tidak boleh sama.

#### Penyelesaian:
Dengan segala pertimbangan syarat di atas, muncullah
#### [Kodingan ini](soal3.sh) :
```
#!/bin/bash

i=1
pass=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)

while [ -f ./password"$i".txt ]
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
```
+ `i=1` inisialisasi variabel _i_ untuk kepentingan iterasi
+  `pass=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)` mengisi variabel _pass_ dengan output dari perintah di dalamnya (command ini saya pakai untuk generate password-nya)
     + `head /dev/urandom` mencetak bagian awal dari `/dev/urandom`
     + `tr -dc A-Za-z0-9` digunakan agar hanya tersisa character-character `a-z`, `A-Z`, dan `0-9` dari output perintah sebelumnya
     + `head -c 12` digunakan untuk mengambil 12 karakter pertama dari output perintah sebelumnya.
+ `while [ -f ./password"$i".txt ]` selama ada file yang bernama password"$i".txt maka perintah-perintah dalam while akan dijalankan.
    + `-f` digunakan untuk memeriksa keberadaan file yang dicari. Bila ada, output-nya adalah _true_
```
if [ "$pass" == "$(cat ./password"$i".txt)" ]
then
   pass=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
   i=1
 else
   let "i++"
fi
``` 
memeriksa apakah password yang baru di-generate sama dengan password yang tersimpan. Bila iya maka password baru akan digenerate dan i kembali bernilai 1 untuk memeriksa adakah kesamaan dengan password-password yang tersimpan (dengan bantuan fungsi _while_). Sedangkan bila tidak ada password tersimpan yang bernilai sama dengan password yang baru di-generate, maka i akan ditambah 1.
+ `echo "$pass" >> password"$i".txt` bila pemeriksaan-pemeriksaan di atas telah dilewati, perintah ini lah yang akan menyimpan password-nya ke dalam file.
    + `echo "$pass"` meng-output-kan variabel $pass
    + `>> password"$i".txt` menyimpan output dari dari perintah sebelumnya ke dalam file password"$i".txt dimana $i adalah nilai i terakhir setelah berbagai pengecekan yang telah dilalui.
