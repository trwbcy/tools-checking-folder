#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'
HIGHLIGHT='\033[1;1m\033[48;5;239m'
#logger echo -e "${GREEN}"
echo "████████╗██████╗░░██╗░░░░░░░██╗██████╗░░█████╗░██╗░░░██╗"
echo "╚══██╔══╝██╔══██╗░██║░░██╗░░██║██╔══██╗██╔══██╗╚██╗░██╔╝"
echo "░░░██║░░░██████╔╝░╚██╗████╗██╔╝██████╦╝██║░░╚═╝░╚████╔╝░"
echo "░░░██║░░░██╔══██╗░░████╔═████║░██╔══██╗██║░░██╗░░╚██╔╝░░"
echo "░░░██║░░░██║░░██║░░╚██╔╝░╚██╔╝░██████╦╝╚█████╔╝░░░██║░░░"
echo "░░░╚═╝░░░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═════╝░░╚════╝░░░░╚═╝░░░"
echo -e "${NC}"

 function logger(){
    MESSAGE=$1
    echo "`/bin/date +%Y-%m-%d\ %H:%M:%S` | apps | ${MESSAGE}"
    echo "`/bin/date +%Y-%m-%d\ %H:%M:%S` | apps | ${MESSAGE}" >> ${logfile}
}

# Memeriksa apakah argumen tanggal telah diberikan
if [[ -z $1 ]]; then
  echo -e "${GREEN}Error: Harap berikan argumen tanggal dalam format YYYYMMDD_YYYYMMDD.${NC}"
  exit 1
fi
# Memeriksa apakah argumen tanggal memiliki format yang benar
if [[ ! $1 =~ ^[0-9]{8}_[0-9]{8}$ ]]; then
  echo -e "${GREEN}Error: Format tanggal tidak valid. Harap gunakan format YYYYMMDD_YYYYMMDD.${NC}"
  exit 1
fi
# Mendapatkan path folder dari argumen tanggal
folder1="/data/tsel/g_xc/airflow/script/rpa_probing/dataset/image/$1"
# Memeriksa apakah folder 1 ada
if [[ ! -d $folder1 ]]; then
  echo -e "${GREEN}Error: Folder $1 tidak ditemukan.${NC}"
  exit 1
fi
# Mendapatkan daftar folder dalam folder 1
folders1=$(find "$folder1" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | tr '[:upper:]' '[:lower:]')
# Memeriksa folder yang tersedia di folder 1
echo -e "${GREEN}Folder yang tersedia pada tanggal $1:${NC}"
echo -e "${GREEN}==============================================${NC}"
available_folders=("axis" "tri" "xl" "im3" "smartfren")
found_available_folders=false
for folder in "${available_folders[@]}"; do
  found=false
  for folder_name in "${folders1[@]}"; do
    if [[ $folder_name == *"$folder"* ]]; then
      found=true
      found_available_folders=true
      echo -e "${HIGHLIGHT}$folder${NC}"
      break
    fi
  done
  if [[ $found == false ]]; then
    missing_folders+=("$folder")
  fi
done

if [[ $found_available_folders == false ]]; then
  echo -e "${HIGHLIGHT}Tidak ada folder yang tersedia pada tanggal $1${NC}"
fi
# Memeriksa folder yang tidak ditemukan di folder 1
echo -e "${GREEN}Folder yang tidak ditemukan pada tanggal $1:${NC}"
echo -e "${GREEN}==============================================${NC}"

missing_folders=()
for folder in "${available_folders[@]}"; do
  found=false
  for folder_name in "${folders1[@]}"; do
    if [[ $folder_name == *"$folder"* ]]; then
      found=true
      break
    fi
  done
  if [[ $found == false ]]; then
    missing_folders+=("$folder")
    echo -e "${HIGHLIGHT}$folder${NC}"
  fi
done