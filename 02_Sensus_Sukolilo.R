# ============================================================
# SCRIPT 2: PENGOLAHAN DATA TABULAR & SENSUS KELURAHAN
# ============================================================

# 0. DIREKTORI KERJA
setwd("D:/PRIVATE/Pemograman_Spasial/Rstudio") # Sesuaikan foldermu
dir.create("output", showWarnings = FALSE, recursive = TRUE)

# 1. MEMBUAT DATA FRAME SENSUS KELURAHAN KECAMATAN SUKOLILO
df_sensus <- data.frame(
  kelurahan = c("Keputih", "Klampis Ngasem", "Medokan Semampir", "Semolowaru"),
  jumlah_penduduk = c(45000, 32000, 51000, 48000),
  kepadatan_jiwa_per_km2 = c(4100, 7500, 6200, 5900),
  zona_risiko = c("Rendah", "Sedang", "Tinggi", "Sedang")
)

cat("--- TABEL SENSUS KELURAHAN SUKOLILO ---\n")
print(df_sensus)

# 2. STRUKTUR & RINGKASAN DATA
cat("\n--- STRUKTUR DATA (STR) ---\n")
str(df_sensus)

cat("\n--- RINGKASAN STATISTIK (SUMMARY) ---\n")
print(summary(df_sensus))

# 3. FILTERING / INDEXING DATA TABEL
# Mengambil kelurahan dengan jumlah penduduk di atas 45.000 jiwa
sensus_padat <- df_sensus[df_sensus$jumlah_penduduk > 45000, ]
cat("\nKelurahan dengan penduduk > 45.000 jiwa:\n")
print(sensus_padat)

# Menghitung total penduduk dan rata-rata kepadatan
total_penduduk <- sum(df_sensus$jumlah_penduduk)
rata_kepadatan <- mean(df_sensus$kepadatan_jiwa_per_km2)

cat("\nTotal Penduduk Sukolilo (Sampel):", total_penduduk, "jiwa\n")
cat("Rata-rata Kepadatan:", round(rata_kepadatan, 2), "jiwa/km2\n")

# 4. EXPORT DATA KE CSV
write.csv(df_sensus, "output/sensus_sukolilo_bersih.csv", row.names = FALSE)
cat("\n[SUKSES] Script Sensus selesai dan file 'sensus_sukolilo_bersih.csv' tersimpan di folder output!\n")