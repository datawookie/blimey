library(dplyr)
library(purrr)
library(readxl)
library(here)
library(janitor)
library(usethis)

# These data are from https://gov.wales/address-list-schools.

XLSX <- here("data-raw", "school-wales-address-list.xlsx")

SHEETS <- c("A_gynhelir", "Annibynnol", "UCD", "Maintained", "Independent", "PRU")

schools_wales <- map_dfr(SHEETS, function(sheet) {
  schools <- read_xlsx(XLSX, sheet = sheet) %>%
    clean_names()

  if ("cod_post" %in% names(schools)) {
    schools <- schools %>%
      rename(
        postcode = cod_post
      )
  }

  if ("rhif_ffon" %in% names(schools)) {
    schools <- schools %>%
      rename(
        phone_number = rhif_ffon
      )
  }

  if ("rhif_yr_ysgol" %in% names(schools)) {
    schools <- schools %>%
      rename(
        school_id = rhif_yr_ysgol
      )
  } else {
    schools <- schools %>%
      rename(
        school_id = school_number
      )
  }

  if ("enw_r_ysgol" %in% names(schools)) {
    schools <- schools %>%
      rename(
        school_name = enw_r_ysgol
      )
  }

  if ("awdurdod_lleol" %in% names(schools)) {
    schools <- schools %>%
      rename(
        local_authority = awdurdod_lleol,
        local_authority_id = cod_a_ll
      )
  } else {
    schools <- schools %>%
      rename(
        local_authority_id = la_code
      )
  }

  if (any(any(grepl("cyfeiriad", names(schools))))) {
    schools <- schools %>%
      rename(
        address_1 = cyfeiriad_1,
        address_2 = cyfeiriad_2,
        address_3 = cyfeiriad_3,
        address_4 = cyfeiriad_4
      )
  }

  schools
})

schools_wales %>%
  select(
    school_id, school_name, local_authority_id, local_authority,
    # address_1, address_2, address_3, address_4,
    postcode,
    phone_number
  ) %>%
  arrange(school_id)

use_data(schools_wales, overwrite = TRUE)
