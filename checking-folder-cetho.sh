#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'
HIGHLIGHT='\033[1;1m\033[48;5;239m'
echo -e "${GREEN}"
echo "  ▄▄▄█████▓ ██▀███   █     █░ ▄▄▄▄    ▄████▄▓██   ██▓"
echo "  ▓  ██▒ ▓▒▓██ ▒ ██▒▓█░ █ ░█░▓█████▄ ▒██▀ ▀█ ▒██  ██▒"
echo "  ▒ ▓██░ ▒░▓██ ░▄█ ▒▒█░ █ ░█ ▒██▒ ▄██▒▓█    ▄ ▒██ ██░"
echo "  ░ ▓██▓ ░ ▒██▀▀█▄  ░█░ █ ░█ ▒██░█▀  ▒▓▓▄ ▄██▒░ ▐██▓░"
echo "    ▒██▒ ░ ░██▓ ▒██▒░░██▒██▓ ░▓█  ▀█▓▒ ▓███▀ ░░ ██▒▓░"
echo "    ▒ ░░   ░ ▒▓ ░▒▓░░ ▓░▒ ▒  ░▒▓███▀▒░ ░▒ ▒  ░ ██▒▒▒"
echo "      ░      ░▒ ░ ▒░  ▒ ░ ░  ▒░▒   ░   ░  ▒  ▓██ ░▒░"
echo "    ░        ░░   ░   ░   ░   ░    ░ ░       ▒ ▒ ░░"
echo "              ░         ░     ░      ░ ░     ░ ░"
echo "                                   ░ ░       ░ ░"
echo -e "${NC}"
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
data_folder="/data/tsel/g_xc/airflow/script/rpa_probing/dataset/umb_cetho"
date_folder1="${1}"
# Daftar file yang harus ada dalam folder (dalam huruf kecil)
required_files=("indosat" "xl" "axis" "tri" "smartfren")
# Fungsi untuk menampilkan isi folder dan file yang ada
function display_folder_content() {
  local folder_path=$1
  echo -e "${GREEN}Isi folder ${folder_path}:${NC}"
  echo -e "${GREEN}==============================================${NC}"
  ls -l "${folder_path}"
  echo
}
# Fungsi untuk menampilkan daftar file yang kurang
function display_missing_files() {
  local missing_files=("$@")
  if [[ ${#missing_files[@]} -eq 0 ]]; then
    echo -e "${HIGHLIGHT}Semua file lengkap dalam ${data_folder}/${date_folder1}${NC}"
  else
    echo -e "${GREEN}Terdapat file missing di dalam ${data_folder}/${date_folder1}:${NC}"
    echo -e "${GREEN}==============================================${NC}"
    for file in "${missing_files[@]}"; do
      echo -e "${HIGHLIGHT}${file}${NC}"
    done
  fi
  echo
}
# Memeriksa keberadaan folder 1
if [[ -d "${data_folder}/${date_folder1}" ]]; then
  display_folder_content "${data_folder}/${date_folder1}"
  missing_files1=()
  for file in "${required_files[@]}"; do
    if ! find "${data_folder}/${date_folder1}" -iname "*${file}*" >/dev/null 2>&1; then
      missing_files1+=("${file}")
    fi
  done
  display_missing_files "${missing_files1[@]}"
else
  echo -e "${GREEN}Folder ${data_folder}/${date_folder1} tidak ditemukan.${NC}"
fi
