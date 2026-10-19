# ================================================================
# SPATIAL PROGRAMMING WITH R - WEEK 1
# Pengantar Pemrograman Data Spasial
# ================================================================
# Tujuan:
# 1) Mengenal workflow R/RStudio untuk spatial programming
# 2) Mengenal package ecosystem: tidyverse, sf, terra, tmap, leaflet
# 3) Memahami variable, data type, data structure, indexing, coercion
# 4) Memahami arithmetic, comparison, logical, dan string operators
# 5) Menghubungkan dasar R dengan objek spasial sf
#
# Cara pakai:
# - Buka file ini di RStudio.
# - Klik Source untuk menjalankan seluruh script, atau jalankan per bagian.
# - Pertama kali dijalankan, script akan menginstal package yang belum ada.
# ================================================================

# ------------------------------------------------
# 0. CLEAN START
# ------------------------------------------------
rm(list = ls()) # Membersihkan variabel di Environment

# Opsional: Atur folder kerja ke lokasi file script ini disimpan (jika diperlukan)
# Atau biarkan menggunakan Working Directory bawaan RStudio saat ini:
cat("Working directory saat ini:", getwd(), "\n")

cat("\n============================================\n")
cat("SPATIAL PROGRAMMING WITH R - WEEK 1\n")
cat("============================================\n\n")
print("\n============================================\n")

# ------------------------------------------------
# 1. PACKAGE SETUP
# 
# ------------------------------------------------
required_packages <- c(
  "tidyverse",
  "sf",
  "terra",
  "leaflet",
  "tmap",
  "glue"
)

installed <- rownames(installed.packages())
missing_packages <- setdiff(required_packages, installed)

if (length(missing_packages) > 0) {
  message("Installing missing packages: ", paste(missing_packages, collapse = ", "))
  install.packages(missing_packages, dependencies = TRUE)
}

suppressPackageStartupMessages({
  library(tidyverse)
  library(sf)
  library(terra)
  library(leaflet)
  library(tmap)
})

cat("Packages loaded successfully.\n")


# ------------------------------------------------
# 2. R / RSTUDIO WORKSPACE CHECK
# 
# ------------------------------------------------
cat("\n--- WORKSPACE CHECK ---\n")
cat("Current working directory:\n")
print(getwd())

cat("\nFiles in current directory:\n")
print(list.files())

cat("\nR session information:\n")
print(sessionInfo())


# ------------------------------------------------
# 3. PROJECT DIRECTORY BEST PRACTICES
#
# ------------------------------------------------
cat("\n--- PROJECT DIRECTORY ---\n")

# Membuat struktur folder sederhana.
# showWarnings = FALSE agar tidak error bila folder sudah ada.
dir.create("data", showWarnings = FALSE)
dir.create("scripts", showWarnings = FALSE)
dir.create("output", showWarnings = FALSE)

cat("Folder structure prepared:\n")
print(c("data/", "scripts/", "output/"))


# ------------------------------------------------
# 4. FIRST SPATIAL OBJECT WITH sf
# 
# ------------------------------------------------
cat("\n--- FIRST SPATIAL OBJECT ---\n")

nc_path <- system.file("shape/nc.shp", package = "sf")

if (nc_path == "") {
  stop("Sample nc.shp tidak ditemukan pada package sf.")
}

nc <- st_read(nc_path, quiet = TRUE)

cat("Class of nc:\n")
print(class(nc))

cat("\nFirst rows:\n")
print(head(nc))

cat("\nCoordinate Reference System:\n")
print(st_crs(nc))

cat("\nGeometry type:\n")
print(unique(st_geometry_type(nc)))

# Plot geometri saja
plot(st_geometry(nc), main = "North Carolina - sf geometry")


# ------------------------------------------------
# 5. VARIABLES AND ASSIGNMENT
# 
# ------------------------------------------------
cat("\n--- VARIABLES ---\n")

age <- 54
city_name <- "Surabaya"
has_river <- TRUE
landslide_count <- 8L
rainfall_mm <- 125.6

print(age)
print(city_name)
print(has_river)
print(landslide_count)
print(rainfall_mm)

# R is case-sensitive
Age <- 20
AGE <- 30

cat("\nCase-sensitive variable names:\n")
print(c(age = age, Age = Age, AGE = AGE))

# Nama variabel yang disarankan
mean_rainfall_mm <- 210.5
city_population <- 3200000
slope_degree <- 35.2


# ------------------------------------------------
# 6. BASIC DATA TYPES
# 
# ------------------------------------------------
cat("\n--- DATA TYPES ---\n")

elevation <- 125.6        # numeric
building_count <- 10L     # integer
feature_name <- "river"   # character
flooded <- TRUE           # logical
complex_number <- 1 + 4i  # complex
missing_value <- NA       # missing value
null_object <- NULL       # absence of an object/value
not_a_number <- NaN       # special numeric value

atomic_objects <- list(
  elevation = elevation,
  building_count = building_count,
  feature_name = feature_name,
  flooded = flooded,
  complex_number = complex_number,
  missing_value = missing_value,
  null_object = null_object,
  not_a_number = not_a_number
)

for (nm in names(atomic_objects)) {
  x <- atomic_objects[[nm]]
  cat("\n", nm, "\n", sep = "")
  print(x)
  cat("class :", paste(class(x), collapse = ", "), "\n")
  cat("typeof:", typeof(x), "\n")
}


# ------------------------------------------------
# 7. IDENTIFYING DATA TYPES
# 
# ------------------------------------------------
cat("\n--- IDENTIFYING TYPES ---\n")

print(class(10.5))
print(typeof(10L))
print(is.numeric("10"))
print(is.numeric(10))
print(is.character("10"))
print(is.logical(TRUE))


# ------------------------------------------------
# 8. BASIC DATA STRUCTURES
# 
# ------------------------------------------------
cat("\n--- DATA STRUCTURES ---\n")

# 8.1 Vector: semua elemen harus menjadi satu tipe yang kompatibel
coordinates_x <- c(112.5, 112.7, 112.9)
rainfall_values <- c(120, 145, 98)

print(coordinates_x)
print(rainfall_values)
print(class(rainfall_values))

# Mixed vector: angka/logical akan dicoerce menjadi character
mixed_vector <- c(5.7, 4, "yes", TRUE)
cat("\nMixed vector:\n")
print(mixed_vector)
print(typeof(mixed_vector))

# 8.2 List: dapat menyimpan tipe objek yang berbeda
city <- list(
  name = "Agam",
  population = 351000,
  coastal = FALSE,
  coordinates = c(100.16, -0.22)
)

print(city)

# 8.3 Matrix: struktur 2D dengan satu tipe data
raster_like_matrix <- matrix(1:9, nrow = 3, ncol = 3)
print(raster_like_matrix)

# 8.4 data.frame
sites_df <- data.frame(
  site = c("A", "B", "C"),
  longitude = c(112.50, 112.70, 112.90),
  latitude = c(-7.20, -7.35, -7.50),
  rainfall_mm = c(120, 145, 98)
)
print(sites_df)

# 8.5 tibble
sites_tbl <- tibble(
  site = c("A", "B", "C"),
  longitude = c(112.50, 112.70, 112.90),
  latitude = c(-7.20, -7.35, -7.50),
  rainfall_mm = c(120, 145, 98)
)
print(sites_tbl)


# ------------------------------------------------
# 9. INDEXING IN R
# 
# ------------------------------------------------
cat("\n--- INDEXING ---\n")

values <- c(5.7, 4, "yes", TRUE)

cat("First element: ")
print(values[1])

cat("Third element: ")
print(values[3])

cat("Elements 1 to 3: ")
print(values[1:3])

cat("\nNamed list indexing:\n")
print(city$name)
print(city[["population"]])

cat("\nData-frame column indexing:\n")
print(sites_df$rainfall_mm)
print(sites_df[1, ])      # row 1
print(sites_df[, "site"]) # one column

cat("\nsf attribute and geometry access:\n")
print(head(nc$NAME))
print(head(st_geometry(nc), 2))


# ------------------------------------------------
# 10. TYPE CONVERSION / COERCION
# 
# ------------------------------------------------
cat("\n--- TYPE CONVERSION ---\n")

numeric_from_text <- as.numeric("125.6")
text_from_number <- as.character(2026)
logical_from_number <- as.logical(1)
date_value <- as.Date("2026-09-07")
land_class <- factor(c("urban", "rural", "urban", "forest"))

print(numeric_from_text)
print(text_from_number)
print(logical_from_number)
print(date_value)
print(land_class)

# Contoh potensi masalah
bad_numeric <- suppressWarnings(as.numeric("125 mm"))
cat("\nConverting '125 mm' directly to numeric gives:\n")
print(bad_numeric)

# Cara sederhana membersihkan teks sebelum konversi
clean_numeric <- as.numeric(gsub(" mm", "", "125 mm"))
print(clean_numeric)


# ------------------------------------------------
# 11. ARITHMETIC OPERATORS
#
# ------------------------------------------------
cat("\n--- ARITHMETIC OPERATORS ---\n")

print(4 + 3)       # addition
print(4 - 3)       # subtraction
print(4 * 3)       # multiplication
print(7 / 2)       # division
print(7 %% 2)      # modulo
print(7 %/% 2)     # integer/floor division
print(7 ^ 2)       # power

cat("\nOperator precedence:\n")
print(4 + 3 ^ 2)       # 13
print((4 + 3) ^ 2)     # 49
print(16 ^ 2 / 4)


# ------------------------------------------------
# 12. COMPARISON OPERATORS
# 
# ------------------------------------------------
cat("\n--- COMPARISON OPERATORS ---\n")

x <- 5

print(x == 5)
print(x != 5)
print(x < 7)
print(x > 7)
print(x <= 5)
print(x >= 5)

city_code <- "A"
print(city_code %in% c("A", "B"))

# Spatial-like attributes
slope <- 35
rainfall_mm <- 120
landuse <- "settlement"
dist_river <- 180

print(slope > 30)
print(rainfall_mm >= 100)
print(landuse != "water")


# ------------------------------------------------
# 13. LOGICAL OPERATORS
# 
# ------------------------------------------------
cat("\n--- LOGICAL OPERATORS ---\n")

x <- 14
y <- 42

x_divisible <- (x %% 2) == 0
y_divisible <- (y %% 3) == 0

cat("x divisible by 2:", x_divisible, "\n")
cat("y divisible by 3:", y_divisible, "\n")

print(x_divisible & y_divisible)  # AND
print(x_divisible | FALSE)        # OR
print(!x_divisible)               # NOT
print(!(x_divisible & y_divisible))

# Contoh logika untuk analisis spasial
high_risk <- slope > 30 & rainfall_mm > 100
settlement_near_river <- landuse == "settlement" & dist_river < 250

cat("High risk:", high_risk, "\n")
cat("Settlement near river:", settlement_near_river, "\n")


# ------------------------------------------------
# 14. VECTORISED LOGICAL FILTERING
# 
# ------------------------------------------------
cat("\n--- VECTORISED FILTERING ---\n")

hazard_table <- tibble(
  location = c("A", "B", "C", "D", "E"),
  slope = c(12, 35, 42, 18, 31),
  rainfall_mm = c(80, 120, 155, 110, 95),
  landuse = c("forest", "settlement", "settlement", "water", "agriculture")
)

print(hazard_table)

high_risk_locations <- hazard_table %>%
  filter(slope > 30 & rainfall_mm > 100)

cat("\nLocations meeting both conditions:\n")
print(high_risk_locations)


# ------------------------------------------------
# 15. STRING OPERATIONS
# 
# ------------------------------------------------
cat("\n--- STRING OPERATIONS ---\n")

x <- "R"
y <- "spatial"

# Combine with a space
print(paste(x, y))

# Combine without automatic spaces
print(paste0(x, "-", y))

# Repeat text
print(strrep("map ", 3))

# stringr examples
print(stringr::str_to_upper("spatial programming"))
print(stringr::str_detect("spatial programming", "spatial"))

# glue template
area_name <- "Surabaya"
print(glue::glue("Study area: {area_name}"))

# Python-like string addition DOES NOT work in R.
# The try() keeps this script running while showing the error object.
wrong_string_operation <- try("R" + "spatial", silent = TRUE)
cat("\nAttempting 'R' + 'spatial' in R produces:\n")
print(wrong_string_operation)


# ------------------------------------------------
# 16. MIXING STRINGS AND NUMBERS
# 
# ------------------------------------------------
cat("\n--- STRINGS + NUMBERS ---\n")

x <- 6
answer <- (x * 5345) %/% 763

print(answer)
print(paste("The answer is", answer))
print(glue::glue("The answer is {answer}"))

population <- 3250000
popup <- paste("Population:", format(population, big.mark = ","))
print(popup)


# ------------------------------------------------
# 17. MINI LAB - FROM VALUES TO A SIMPLE MAP
# 
# ------------------------------------------------
cat("\n--- MINI LAB: sf OBJECT ---\n")

# Create a new categorical attribute from an existing numeric attribute
nc_lab <- nc %>%
  mutate(
    area_class = if_else(
      AREA > median(AREA, na.rm = TRUE),
      "large",
      "small"
    )
  )

cat("Class of nc_lab:\n")
print(class(nc_lab))

cat("\nNew variable area_class:\n")
print(table(nc_lab$area_class, useNA = "ifany"))

cat("\nCRS:\n")
print(st_crs(nc_lab))

cat("\nStructure:\n")
glimpse(nc_lab)

# Base sf plot
plot(nc_lab["area_class"], main = "Area Class - sf plot")

# ggplot2 map
map_plot <- ggplot(nc_lab) +
  geom_sf(aes(fill = area_class)) +
  labs(
    title = "Area Classification",
    subtitle = "Above vs. below median AREA",
    fill = "Area class"
  ) +
  theme_minimal()

print(map_plot)

# Save output to project folder
ggsave(
  filename = file.path("output", "week01_area_class_map.png"),
  plot = map_plot,
  width = 8,
  height = 6,
  dpi = 150
)

cat("\nMap saved to: output/week01_area_class_map.png\n")