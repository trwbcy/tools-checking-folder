#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'
logfile=/home/analytic_ops/sms/tri/logs/probing_check_source.log

function logger(){
    MESSAGE=$1
    echo "`/bin/date +%Y-%m-%d\ %H:%M:%S` | web_commerce | ${MESSAGE}"
    echo "`/bin/date +%Y-%m-%d\ %H:%M:%S` | web_commerce | ${MESSAGE}" >> ${logfile}
}
# ASCII art
echo -e ${GREEN}'
  ▄▄▄█████▓ ██▀███   █     █░ ▄▄▄▄    ▄████▄▓██   ██▓
  ▓  ██▒ ▓▒▓██ ▒ ██▒▓█░ █ ░█░▓█████▄ ▒██▀ ▀█ ▒██  ██▒
  ▒ ▓██░ ▒░▓██ ░▄█ ▒▒█░ █ ░█ ▒██▒ ▄██▒▓█    ▄ ▒██ ██░
  ░ ▓██▓ ░ ▒██▀▀█▄  ░█░ █ ░█ ▒██░█▀  ▒▓▓▄ ▄██▒░ ▐██▓░
    ▒██▒ ░ ░██▓ ▒██▒░░██▒██▓ ░▓█  ▀█▓▒ ▓███▀ ░░ ██▒▓░
    ▒ ░░   ░ ▒▓ ░▒▓░░ ▓░▒ ▒  ░▒▓███▀▒░ ░▒ ▒  ░ ██▒▒▒
      ░      ░▒ ░ ▒░  ▒ ░ ░  ▒░▒   ░   ░  ▒  ▓██ ░▒░
    ░        ░░   ░   ░   ░   ░    ░ ░       ▒ ▒ ░░
              ░         ░     ░      ░ ░     ░ ░
                                   ░ ░       ░ ░
'${NC}
# Memeriksa jumlah argumen
if [ $# -ne 1 ]; then
  echo "Usage: $0 <tanggal_start>"
  exit 1
fi
# Memisahkan tanggal start menjadi dua bagian
tanggal_start=($(echo $1 | tr "_" " "))
logger " pengecekkan untuk file $tanggal_start"
# Memeriksa apakah tanggal_start yang dimasukkan valid
for tanggal in "${tanggal_start[@]}"; do
    tanggal_tanpa_tanda="${tanggal//-}"
    date -d "$tanggal_tanpa_tanda" >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Tanggal tidak valid: $tanggal"
        exit 1
    fi
done
# Mengimpor dan melakukan listing pada direktori yang sesuai
direktori_utama="/data/tsel/g_xc/airflow/script/rpa_probing/dataset/web"
direktori="$direktori_utama/${tanggal_start[0]}_${tanggal_start[1]}"
if [[ -d "$direktori" ]]; then
    echo "Mengimpor dan melakukan listing pada direktori: $direktori"
    # Memeriksa keberadaan file BliBli.xlsx, Tokopedia.xlsx, dan Bukalapak.csv dalam direktori
    file_blibli=0
    file_tokopedia=0
    file_bukalapak=0
    for file in "$direktori"/*; do
        if [[ -f "$file" ]]; then
            if [[ "$file" == *BliBli* ]]; then
                file_blibli=1
            elif [[ "$file" == *Tokopedia* ]]; then
                file_tokopedia=1
            elif [[ "$file" == *Bukalapak* ]]; then
                file_bukalapak=1
            fi
        fi
    done
    # Menampilkan status file dalam direktori
    if [[ $file_blibli -eq 1 && $file_tokopedia -eq 1 && $file_bukalapak -eq 1 ]]; then
        echo "File lengkap"
        logger " file lengkap"
        ls -lrth "$direktori"
    else
        echo "File tidak lengkap:"
        logger "file tidak lengkap"
        if [[ $file_blibli -eq 0 ]]; then
            echo "  - BliBli.xlsx tidak ditemukan"
            logger "Blibli.xlsx tidak ditemukan"
        fi
        if [[ $file_tokopedia -eq 0 ]]; then
            echo "  - Tokopedia.xlsx tidak ditemukan"
            logger "Tokopedia.xlsx tidak ditemukan"
        fi
        if [[ $file_bukalapak -eq 0 ]]; then
            echo "  - Bukalapak.csv tidak ditemukan"
            logger "Bukalapak.csv tidak ditemukan"
        fi
    fi
    echo "-------------------------------------------------------------------------------------------------------------------"
else
    echo "Direktori tidak ditemukan: $direktori"
    logger "Direktori tidak ditemukan: $direktori"
fi
