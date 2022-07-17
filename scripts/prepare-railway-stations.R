library(here)
library(dplyr)
library(readr)
library(usethis)

railway_stations <- read_csv(
  here(file.path("data-raw", "railway-stations.csv")),
  col_types = cols(
    crs = col_character(),
    iata = col_character(),
    station_name = col_character(),
    lat = col_double(),
    lon = col_double()
  )
)

use_data(railway_stations, overwrite = TRUE)
