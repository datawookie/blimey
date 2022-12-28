library(tidyverse)
library(here)
library(janitor)
library(usethis)

CSV <- here("data-raw", "place-names-2022-dec.csv")

place_names <- read_csv(
  CSV,
  col_types = cols(
    placeid = col_double(),
    place21cd = col_character(),
    placesort = col_character(),
    place21nm = col_character(),
    splitind = col_double(),
    descnm = col_character(),
    ctyhistnm = col_character(),
    cty61nm = col_character(),
    cty91nm = col_character(),
    ctyltnm = col_character(),
    ctry21nm = col_character(),
    cty21cd = col_character(),
    cty21nm = col_character(),
    lad61nm = col_character(),
    lad61desc = col_character(),
    lad91nm = col_character(),
    lad91desc = col_character(),
    lad21cd = col_character(),
    lad21nm = col_character(),
    lad21desc = col_character(),
    ced21cd = col_character(),
    wd21cd = col_character(),
    par21cd = col_character(),
    hlth21cd = col_character(),
    hlth21nm = col_character(),
    regd21cd = col_character(),
    regd21nm = col_character(),
    rgn21cd = col_character(),
    rgn21nm = col_character(),
    npark21cd = col_character(),
    npark21nm = col_character(),
    bua22cd = col_character(),
    pcon21cd = col_character(),
    pcon21nm = col_character(),
    eer21cd = col_character(),
    eer21nm = col_character(),
    pfa21cd = col_character(),
    pfa21nm = col_character(),
    gridgb1m = col_character(),
    gridgb1e = col_character(),
    gridgb1n = col_character(),
    grid1km = col_character(),
    lat = col_double(),
    long = col_double()
  ),
  locale = locale(encoding = "latin1")
)

place_names <- place_names %>%
  select(
    id = placeid,
    code = place21cd,
    name = place21nm,
    description_code = descnm,
    country_name = ctry21nm,
    county_name = cty21nm,
    lat,
    lon = long
  )

CSV <- here("data-raw", "place-names-descriptions.csv")

place_names_description <- read_csv(
  CSV,
  col_types = cols(
    description_code = col_character(),
    description_text = col_character(),
    description_extent = col_character()
  )
)

use_data(place_names, overwrite = TRUE)
use_data(place_names_description, overwrite = TRUE)
