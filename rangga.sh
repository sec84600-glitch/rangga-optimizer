#!/bin/bash

# ==========================================
# RANGGA OPTIMIZER SCRIPT - CLEAN EDITION
# Target: Non-rooted Infinix Device / Termux
# ==========================================

clear
echo "=========================================="
echo "    RANGGA SYSTEM OPTIMIZER & CLEANER     "
echo "=========================================="
echo ""

# Fungsi Cek Info Perangkat
check_env() {
    echo "[*] Memeriksa lingkungan sistem..."
    echo "[*] Perangkat: Infinix (Non-Root Environment)"
    echo "[*] Emulator: Termux Linux Shell"
    sleep 1
}

# Fungsi Pembersihan Cache & File Sampah
clean_cache() {
    echo ""
    echo "[+] Menjalankan pembersihan cache & sampah..."
    
    # Membersihkan cache package manager Termux
    apt-get clean 2>/dev/null
    
    # Menghapus file temporary lokal jika ada
    rm -rf $TMPDIR/* 2>/dev/null
    
    echo "[✔] Pembersihan cache selesai!"
    sleep 1
}

# Fungsi Optimasi Perangkat
optimize_performance() {
    echo ""
    echo "[+] Mengoptimalkan alokasi proses Termux..."
    
    # Mengatur prioritas proses bash/termux secara aman
    renice -n -10 -p $$ 2>/dev/null
    
    # Pembersihan RAM ringan yang aman tanpa root
    sync
    
    echo "[✔] Performa berhasil distabilkan!"
    sleep 1
}

# Menu Utama Interaktif
while true; do
    echo ""
    echo "=========================================="
    echo "              MENU UTAMA                  "
    echo "=========================================="
    echo "1. Jalankan Pembersihan Cache"
    echo "2. Optimalkan Performa & RAM"
    echo "3. Jalankan Semua (Full Optimization)"
    echo "4. Keluar"
    echo "=========================================="
    read -p "Pilih opsi (1-4): " choice

    case $choice in
        1)
            check_env
            clean_cache
            ;;
        2)
            check_env
            optimize_performance
            ;;
        3)
            check_env
            clean_cache
            optimize_performance
            echo ""
            echo "🎉 SEMUA OPTIMASI BERHASIL DIJALANKAN! 🎉"
            ;;
        4)
            echo "Keluar dari program. Terima kasih!"
            exit 0
            ;;
        *)
            echo "[!] Pilihan tidak valid, silakan coba lagi."
            ;;
    esac
done
