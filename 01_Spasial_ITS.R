# ============================================================
# MINGGU 3 - SPATIAL PROGRAMMING DENGAN R (NOVARIO'S VERSION)
# 
# ============================================================

# ============================================================
# 0. CEK PACKAGE
# ============================================================
setwd("D:/PRIVATE/Pemograman_Spasial/Rstudio") # Sesuaikan path foldermu jika perlu

cek_package <- function(pkg) {
  requireNamespace(pkg, quietly = TRUE)
}

package_wajib <- c("sf", "terra")

package_hilang <- package_wajib[
  !vapply(package_wajib, cek_package, logical(1))
]

if (length(package_hilang) > 0) {
  stop(
    paste0(
      "\nPACKAGE BELUM TERPASANG: ",
      paste(package_hilang, collapse = ", "),
      "\n\nInstall SATU KALI dari Console RStudio:\n",
      'install.packages(c("sf", "terra"))\n\n',
      "Setelah selesai, restart RStudio dan jalankan script kembali.\n"
    ),
    call. = FALSE
  )
}

# Load package spasial utama.
suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(terra))


# ============================================================
# 1. PERSIAPAN FOLDER
# ============================================================

dir.create("data", showWarnings = FALSE, recursive = TRUE)
dir.create("output", showWarnings = FALSE, recursive = TRUE)
dir.create("scripts", showWarnings = FALSE, recursive = TRUE)

set.seed(42)

cat("Working directory:\n")
print(getwd())


# ============================================================
# VARIABEL DI R
# ============================================================

nama <- "Novario"
Age <- 20
has_W2 <- TRUE

age <- 1
Age <- 2
AGE <- 3

cat("\nNama:", nama, "| Usia:", Age, "\n")


# ============================================================
# TIPE DATA DASAR
# ============================================================

x_int <- 124L
x_num <- 124.56
x_chr <- "Spatial Programming"
x_log <- TRUE
x_na  <- NA

class(x_int)
class(x_num)
class(x_chr)
class(x_log)


# ============================================================
# KONVERSI TIPE DATA
# ============================================================

as.numeric("123")
as.character(500)
as.logical(1)
as.Date("2026-09-14")

kelas <- c("forest", "urban", "water")
kelas <- factor(kelas)
print(kelas)


# ============================================================
# VECTOR DAN VECTORIZED OPERATIONS
# ============================================================

koordinat_x <- c(112.790, 112.793, 112.795)
koordinat_x * 2

elevasi <- c(4.5, 12.0, 3.0, 15.0)
elevasi > 5
elevasi[elevasi > 5]


# ============================================================
# INDEXING & SLICING
# ============================================================

x <- c(10, 20, 30, 40, 50)
x[1]
x[2:4]

peta_index <- data.frame(
  id = 1:5,
  nama = c("A", "B", "C", "D", "E"),
  populasi = c(1000, 2500, 1800, 3200, 1500),
  lon = c(112.79, 112.80, 112.81, 112.82, 112.83),
  lat = c(-7.28, -7.29, -7.30, -7.31, -7.32),
  elevasi = c(4, 12, 3, 15, 9)
)

peta_index[peta_index$elevasi > 5, ]


# ============================================================
# DATA FRAME DENGAN LOKASI NYATA (ITS SUKOLILO) - [MODIFIKASI 1]
# ============================================================

peta <- data.frame(
  id = 1:3,
  nama = c("Rektorat ITS", "Teknik Geomatika", "Perpustakaan ITS"),
  lon = c(112.790, 112.793, 112.795),
  lat = c(-7.282, -7.284, -7.286),
  elevasi = c(4.5, 5.0, 6.2)
)

print(peta)


# ============================================================
# DATA FRAME MENJADI OBJEK SPASIAL sf
# ============================================================

titik_sf <- st_as_sf(
  peta,
  coords = c("lon", "lat"),
  crs = 4326
)

print(titik_sf)
st_geometry_type(titik_sf)
st_crs(titik_sf)


# ============================================================
# VISUALISASI PETA DENGAN KUSTOMISASI - [MODIFIKASI 2]
# ============================================================

cat("\n--- MENAMPILKAN PETA KUSTOM ---\n")

# Plot geometri dengan simbol segitiga, warna hijau tua, dan ukuran diperbesar
plot(st_geometry(titik_sf), 
     pch = 17,          # Simbol titik jadi segitiga
     col = "forestgreen", # Warna titik hijau tua
     cex = 2.0,         # Ukuran simbol lebih besar
     main = "Peta Lokasi Kampus ITS - Modifikasi Novario")

# Tambahkan teks label nama tempat di sebelah titik
text(st_coordinates(titik_sf)[,1], 
     st_coordinates(titik_sf)[,2], 
     labels = titik_sf$nama, 
     pos = 3, 
     cex = 0.8, 
     col = "blue")


# ============================================================
# FUNGSI KUSTOM & EXPORT OUTPUT
# ============================================================

hitung_jarak_3d <- function(x1, y1, z1, x2, y2, z2) {
  dx <- x2 - x1
  dy <- y2 - y1
  dz <- z2 - z1
  jarak_3d <- sqrt(dx^2 + dy^2 + dz^2)
  return(jarak_3d)
}

# Coba uji fungsi jarak 3D kustom
jarak_contoh <- hitung_jarak_3d(0, 0, 0, 3, 4, 12)
cat("Hasil perhitungan jarak 3D kustom:", jarak_contoh, "\n")

# Simpan objek spasial sf ke folder output
saveRDS(
  titik_sf,
  "output/titik_sf_its.rds"
)

cat(
  "\n============================================================\n",
  "SELESAI. Script modifikasi berhasil dijalankan!\n",
  "============================================================\n",
  sep = ""
)