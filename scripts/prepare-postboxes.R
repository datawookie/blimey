library(tidyverse)
library(here)
library(usethis)

# Options for last collection:
#
# Sa
# Mo-Sa
# Mo-Fr
#
postboxes <- read_csv(
  here(file.path("data-raw", "postboxes.csv")),
  col_types = "ccccddcc"
)

postboxes %>% filter(postbox_code %in% c("CV6 269", "GU9 6", "IV51 14", "KT20 87", "LA11 151", "PE1 49",
                                         "PE8 160"))

postboxes <- postboxes %>%
  mutate(
    # Replace "Not collected" with NA.
    last_collection = ifelse(last_collection == "Not collected", NA, last_collection),
    # Remove "Su off" etc.
    last_collection = sub("; (Su|PH) off", "", last_collection),
    last_collection = sub("; Su,PH off", "", last_collection),
    last_collection = sub("; (Sa|PH) unknown", "", last_collection),
    last_collection = ifelse(grepl("always closed", last_collection), NA, last_collection),
    # Add "Sa" prefix to Saturday time (if time present).
    last_collection_saturday = ifelse(
      !is.na(last_collection_saturday),
      paste("Sa", last_collection_saturday),
      NA
    ),
    # Add "Mo-Fr" prefix to Weekday time (if prefix missing).
    last_collection = ifelse(
      !grepl("Mo-Fr", last_collection) & !grepl("Sa", last_collection) & !is.na(last_collection),
      paste("Mo-Fr", last_collection),
      last_collection
    ),
    # Merge.
    last_collection = ifelse(
      !is.na(last_collection_saturday),
      paste(last_collection, last_collection_saturday, sep = "; "),
      last_collection
    )
  ) %>%
  select(-last_collection_saturday)

# Filter out invalid postal codes.
#
postboxes <- postboxes %>% filter(str_detect(postbox_code, "[A-Z]{2}"))

use_data(postboxes, overwrite = TRUE)
