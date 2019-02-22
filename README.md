# SoalShift_modul1_B12

### Outline
+ [Perintah 1](#perintah-1)
    + [Basic Commands](#penyelesaian)
    + [Full Code](#full-code)
+ [Perintah 2](#perintah-2)
    + [2.a](#a)
    + 2.b
    + 2.c

### Perintah 1
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

### Perintah 2
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
