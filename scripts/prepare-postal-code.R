library(dplyr)
library(purrr)
library(readr)
library(here)
library(janitor)
library(usethis)
library(sf)
library(logger)

log_threshold(DEBUG)

options(warn = 2)

source(here("scripts", "prepare-country-code.R"))

# https://www.data.gov.uk/search?filters%5Bpublisher%5D=Ordnance+Survey

# These are the Code-Point Open data from:
#
# https://www.data.gov.uk/dataset/c1e0176d-59fb-4a8c-92c9-c8b376a80687/code-point-open.
#
# Columns:
#
# - postcode units
# - positional quality indicator
# - easting
# - northing
# - country code
# - NHS regional health authority code
# - NHS health authority code
# - administrative county code
# - administrative district code
# - administrative ward code
#
# Contains OS data © Crown copyright and database right 2020 Contains Royal Mail
# data © Royal Mail copyright and Database right 2020 Contains National
# Statistics data © Crown copyright and database right 2020.

FILES <- list.files(here("data-raw", "postal-code"), full.names = TRUE)

postal <- map_dfr(FILES, function(file) {
  log_debug("Reading {file}.")
  read_csv(
    file,
    col_names = c("postcode", "quality_indicator", "easting", "northing", "country_code", "nhs_regional_ha_code", "nhs_ha_code", "county_code", "district_code", "ward_code"),
    col_types = "cdddcccccc",
    progress = FALSE
  )
})

# Convert from easting/northing to longitude/latitude.
#
coordinates <- postal %>%
  st_as_sf(coords = c("easting", "northing"), crs = 27700) %>%
  st_transform(crs = 4326) %>%
  st_coordinates() %>%
  as_tibble() %>%
  rename(lon = X, lat = Y)

postal <- bind_cols(postal, coordinates) %>%
  inner_join(country_code, by = "country_code") %>%
  select(postcode, lat, lon, country_iso)

use_data(postal, overwrite = TRUE)
