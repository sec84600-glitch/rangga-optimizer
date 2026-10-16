#!/bin/bash

# Konfigurasi Log File
LOG_FILE=".rangga_report.txt"
echo "=== LOG AUDIT RANGGA.SH ($(date)) ===" > "$LOG_FILE"

SUCCESS=0
FAILED=0
TOTAL=0

print_status() {
    local status="$1"
    local cmd="$2"
    local msg="$3"
    TOTAL=$((TOTAL + 1))
    
    if [ "$status" -eq 0 ]; then
        echo -e " [\e[1;32m BERHASIL \e[0m] $cmd"
        echo "[BERHASIL] $cmd" >> "$LOG_FILE"
        SUCCESS=$((SUCCESS + 1))
    else
        echo -e " [\e[1;31m GAGAL \e[0m] $cmd --> $msg"
        echo "[GAGAL] $cmd --> $msg" >> "$LOG_FILE"
        FAILED=$((FAILED + 1))
    fi
}

echo "================================================="
echo "   🚀 RANGGA.SH: OPTIMASI & PEMBERSIHAN OTOMATIS"
echo "================================================="

# --- FITUR: HAPUS SKRIP/FILE KONFLIK LAMA ---
echo ""
echo "[*] Tahap 0: Pembersihan Skrip & File Konflik Lama"
OLD_FILES=$(find /sdcard/ /sdcard/Download/ $HOME -maxdepth 2 -type f \( -name "*booster*.sh" -o -name "*tweaks*.sh" -o -name "*game_mode*.sh" \) ! -name "rangga.sh" 2>/dev/null)

if [ -n "$OLD_FILES" ]; then
    for file in $OLD_FILES; do
        rm -f "$file"
        echo -e "     \e[1;31m[DELETED] ->\e[0m $(basename "$file")"
    done
    print_status 0 "Pembersihan skrip lama" "OK"
else
    echo "     [✔] Tidak ada skrip konflik lama yang ditemukan."
    print_status 0 "Pengecekan skrip lama" "Bersih"
fi

# Cek apakah ADB aktif / terhubung
ADB_CMD=""
if adb devices 2>/dev/null | grep -q "device$"; then
    ADB_CMD="adb shell"
    echo "[*] Mode ADB Terdeteksi: Perintah sistem akan dilewatkan via ADB."
else
    echo "[!] Peringatan: ADB belum terhubung. Perintah sistem mungkin ditolak."
fi

# --- TAHAP 1: PEMBERSIHAN CACHE & SAMPAH ---
echo ""
echo "[*] Tahap 1: Pembersihan Sampah & Cache Sistem"
if [ -d "/sdcard/Download" ]; then
    find /sdcard/Download/ -maxdepth 1 -name "*cache*" -type f -delete 2>/dev/null
    print_status 0 "Pembersihan Cache Download" "OK"
fi

# --- TAHAP 2: EKSEKUSI PERINTAH SISTEM VIA ADB ---
echo ""
echo "[*] Tahap 2: Pengaturan Performa Hardware & Sistem"

CMD1="$ADB_CMD cmd power set-mode 1"
eval "$CMD1 > /dev/null 2>&1"
print_status $? "Power High Performance Mode" "Ditolak sistem / Butuh ADB aktif"

CMD2="$ADB_CMD settings put global game_driver_all_apps 1"
eval "$CMD2 > /dev/null 2>&1"
print_status $? "Global Game Driver" "Ditolak XOS / Sandbox"

CMD3="$ADB_CMD settings put system peak_refresh_rate 1"
eval "$CMD3 > /dev/null 2>&1"
print_status $? "Force Peak Refresh Rate" "Ditolak sistem"

CMD4="$ADB_CMD appops set com.facebook.katana RUN_IN_BACKGROUND ignore"
eval "$CMD4 > /dev/null 2>&1"
print_status $? "Restrict Background Apps" "Ditolak sistem"

echo ""
echo "================================================="
echo "   RINGKASAN EKSEKUSI:"
echo "   - Total Perintah Diuji : $TOTAL"
echo "   - Berhasil Diterima    : $SUCCESS"
echo "   - Ditolak / Gagal      : $FAILED"
echo "   - Laporan disimpan ke  : $LOG_FILE"
echo "================================================="
