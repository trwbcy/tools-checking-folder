#!/bin/bash
# Nama file untuk menyimpan hasil analisis
output_file="hasil_analisis.txt"

# Menghapus file output jika sudah ada
if [ -f "$output_file" ]; then
  rm "$output_file"
fi

# Perintah untuk menjalankan dan memformat hasil
perintah="du -h -s /home/analytic_ops/*"

# Menjalankan perintah dan memformat hasil
eval "$perintah" | while read -r line; do
  # Memisahkan ukuran disk dan path menggunakan delimiter tab
  disk_usage=$(echo "$line" | awk -F'\t' '{print $1}')
  path=$(echo "$line" | awk -F'\t' '{print $2}')

# Menuliskan hasil ke file
  echo "Disk Usage: $disk_usage" >> "$output_file"
  echo "Path: $path" >> "$output_file"
  echo >> "$output_file"
done

 

echo "Analisis selesai. Hasil disimpan dalam file: $output_file"
