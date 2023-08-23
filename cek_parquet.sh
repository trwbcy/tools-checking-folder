#!/bin/bash
# Ganti direktori HDFS dengan path yang sesuai
hadoop_direktori="/data/landing/dmp_production/mck_dmp_score/07_model_scoring/external/home_credit/default_probability_score.parquet"
hadoop_direktori2="/data/landing/g_xc_x/"

# Fungsi untuk menampilkan 10 file paling bawah dalam direktori HDFS
function list_10_file_terbawah() {
    echo "List 10 file paling bawah:"
    hdfs dfs -ls -R "$1" | grep -e "\.parquet$" | awk '{print $8}' | sort | tail -n 10
}

# Fungsi untuk memeriksa disk usage (penggunaan disk) pada direktori HDFS
function cek_disk_usage() {
    echo "Disk usage (penggunaan disk) pada direktori "$hadoop_direktori2":"
    hdfs dfs -du -h "$hadoop_direktori2"

}

# Cek apakah direktori HDFS ada
hdfs dfs -test -d "$hadoop_direktori"
if [ $? -eq 0 ]; then
    list_10_file_terbawah "$hadoop_direktori"
    cek_disk_usage "$hadoop_direktori"
else
    echo "Direktori HDFS tidak ditemukan."
fi

