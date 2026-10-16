#!/bin/bash

LOG_FILE=".rangga_report.txt"
echo "=================================================" > "$LOG_FILE"
echo "        LAPORAN AUDIT EKSEKUSI RANGGA.SH         " >> "$LOG_FILE"
echo "        Waktu: $(date)                           " >> "$LOG_FILE"
echo "=================================================" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "[DAFTAR PERINTAH BERHASIL]:" >> "$LOG_FILE"

SUCCESS=0
FAILED=0
TOTAL=0
FAILED_LIST=""

print_status() {
    local status="$1"
    local cmd="$2"
    local msg="$3"
    TOTAL=$((TOTAL + 1))
    
    if [ "$status" -eq 0 ]; then
        echo -e "    \e[1;32m✔ [BERHASIL]\e[0m $cmd"
        echo "  - $cmd" >> "$LOG_FILE"
        SUCCESS=$((SUCCESS + 1))
    else
        echo -e "    \e[1;31m✖ [GAGAL]   \e[0m $cmd \e[1;33m($msg)\e[0m"
        FAILED_LIST="$FAILED_LIST\n    - $cmd Alasan: $msg"
        FAILED=$((FAILED + 1))
    fi
}

clear
echo -e "\e[1;36m=================================================\e[0m"
echo -e "\e[1;35m      🚀 RANGGA.SH PERFORMANCE OPTIMIZER         \e[0m"
echo -e "\e[1;36m=================================================\e[0m"
echo -e "\e[33m [*] Status: Menjalankan Sistem & Pembersihan...\e[0m"
sleep 0.8

echo -e "\n\e[1;34m[ TAHAP 0 ]\e[0m \e[1mPembersihan Skrip & File Konflik Lama\e[0m"
OLD_FILES=$(find /sdcard/ /sdcard/Download/ $HOME -maxdepth 2 -type f \( -name "*booster*.sh" -o -name "*tweaks*.sh" -o -name "*game_mode*.sh" \) ! -name "rangga.sh" 2>/dev/null)

if [ -n "$OLD_FILES" ]; then
    for file in $OLD_FILES; do
        rm -f "$file"
        echo -e "     \e[1;31m[DELETED] ->\e[0m $(basename "$file")"
    done
    print_status 0 "Pembersihan skrip lama" "OK"
else
    echo -e "     \e[32m[✔ Aman] Tidak ada skrip konflik lama.\e[0m"
    print_status 0 "Pengecekan skrip lama" "Bersih"
fi

ADB_CMD=""
if adb devices 2>/dev/null | grep -q "device$"; then
    ADB_CMD="adb shell"
    echo -e " \e[1;32m[✔ ADB Terhubung]\e[0m Perintah dilewatkan via ADB."
else
    echo -e " \e[1;33m[! Peringatan]\e[0m ADB belum aktif/terhubung."
fi
sleep 0.5

echo -e "\n\e[1;34m[ TAHAP 1 ]\e[0m \e[1mPembersihan Sampah & Cache Sistem\e[0m"
if [ -d "/sdcard/Download" ]; then
    find /sdcard/Download/ -maxdepth 1 -name "*cache*" -type f -delete 2>/dev/null
    print_status 0 "Pembersihan Cache Download" "OK"
fi

echo -e "\n\e[1;34m[ TAHAP 2 ]\e[0m \e[1mPengaturan Performa Hardware & Sistem\e[0m"

CMD1="$ADB_CMD cmd power set-mode 1"
eval "$CMD1 > /dev/null 2>&1"
print_status $? "Power High Performance Mode" "Ditolak sistem / Butuh ADB"

CMD2="$ADB_CMD settings put global game_driver_all_apps 1"
eval "$CMD2 > /dev/null 2>&1"
print_status $? "Global Game Driver" "Ditolak XOS / Sandbox"

CMD3="$ADB_CMD settings put system peak_refresh_rate 1"
eval "$CMD3 > /dev/null 2>&1"
print_status $? "Force Peak Refresh Rate" "Ditolak sistem"

CMD4="$ADB_CMD appops set com.facebook.katana RUN_IN_BACKGROUND ignore"
eval "$CMD4 > /dev/null 2>&1"
print_status $? "Restrict Background Apps" "Ditolak sistem"

echo "" >> "$LOG_FILE"
echo "[DAFTAR PERINTAH GAGAL/DITOLAK]:" >> "$LOG_FILE"
if [ -n "$FAILED_LIST" ]; then
    echo -e "$FAILED_LIST" >> "$LOG_FILE"
else
    echo "  - Tidak ada perintah yang gagal (Semua sukses!)" >> "$LOG_FILE"
fi

echo "" >> "$LOG_FILE"
echo "=================================================" >> "$LOG_FILE"
echo " Total: $TOTAL | Berhasil: $SUCCESS | Gagal: $FAILED" >> "$LOG_FILE"
echo "=================================================" >> "$LOG_FILE"

echo -e "\n\e[1;36m=================================================\e[0m"
echo -e "\e[1;33m              RINGKASAN EKSEKUSI                 \e[0m"
echo -e "\e[1;36m=================================================\e[0m"
echo -e " • Total Perintah Diuji  : \e[1m$TOTAL\e[0m"
echo -e " • Berhasil Diterima     : \e[1;32m$SUCCESS\e[0m"
echo -e " • Ditolak / Gagal       : \e[1;31m$FAILED\e[0m"
echo -e " • Laporan Log Tersimpan : \e[1;34m$LOG_FILE\e[0m"
echo -e "\e[1;36m=================================================\e[0m\n"
