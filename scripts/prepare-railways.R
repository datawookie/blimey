library(here)
library(dplyr)
library(readr)
library(janitor)
library(usethis)

railways <- read_csv(
  here(file.path("data-raw", "railways.csv")),
  col_types = cols(
    FID = col_double(),
    ELR = col_character(),
    TRID = col_double(),
    Start_Lat = col_double(),
    End_Lat = col_double(),
    End_Long = col_double(),
    Start_Long = col_double()
  )
) %>%
  clean_names() %>%
  rename(
    lat_start = start_lat,
    lat_end = end_lat,
    lon_start = start_long,
    lon_end = end_long
  )

use_data(railways, overwrite = TRUE)
