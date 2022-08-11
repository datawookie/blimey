library(dplyr)
library(readr)
library(here)
library(janitor)
library(usethis)

# Data downloaded from https://www.compare-school-performance.service.gov.uk/download-data.

CSV <- here("data-raw", "england-school-information.csv")

# URN            - School unique reference number
# LANAME         - Local authority name
# LA             - Local authority number
# ESTAB          - Establishment number
# LAESTAB        - DfE number
# SCHNAME        - School name
# STREET         - School address (1)
# LOCALITY       - School address (2)
# ADDRESS3       - School address (3)
# TOWN           - School town
# POSTCODE       - School postcode
# SCHSTATUS      - School open / closed status
# OPENDATE       - Open date of school (if opened on or after 12th September 2018)
# CLOSEDATE      - Date the school closed
# MINORGROUP     - Type of school / college eg maintained school
# SCHOOLTYPE     - School Type eg Voluntary Aided school
# ISPRIMARY      - Does the school provide primary education? ( 0 = No, 1 = Yes)
# ISSECONDARY    - Does the school provide secondary education? ( 0 = No, 1 = Yes)
# ISPOST16       - Does the school provide post 16 education? (  0 = No, 1 = Yes)
# AGELOW         - Lowest age of entry
# AGEHIGH        - Highest age of entry
# GENDER         - Indicates whether it's a mixed or single sex school
# RELCHAR        - Religious character
# ADMPOL         - Admissions Policy
# OFSTEDLASTINSP - Ofsted last inspection date
# OFSTEDRATING   - Ofsted rating

schools <- read_csv(
  CSV,
  na = c("Not applicable", "Does not apply", "None", "")
) %>%
  clean_names()

local_authority <- schools %>%
  select(local_authority_id = la, local_authority_name = laname) %>%
  unique() %>%
  arrange(local_authority_id)

schools <- schools %>%
  select(
    -laname,
    local_authority_id = la,
    -opendate, -closedate,
    -estab, -laestab,
    -street, -locality, -address3, -town,
    -ispost16
  ) %>%
  rename(
    school_id = urn,
    school_name = schname,
    status = schstatus,
    subtype = minorgroup,
    type = schooltype,
    primary = isprimary,
    secondary = issecondary,
    age_min = agelow,
    age_max = agehigh,
    religion = relchar,
    admission = admpol,
    rating = ofstedrating,
    inspection = ofstedlastinsp
  ) %>%
  mutate(
    type = sub(" school$", "", tolower(type)),
    subtype = sub(" school$", "", tolower(subtype)),
    primary = primary == 1,
    secondary = secondary == 1,
    status = factor(tolower(status)),
    gender = factor(tolower(gender)),
    type = factor(type),
    subtype = factor(subtype),
    religion = factor(religion),
    admission = tolower(admission),
    admission = ifelse(is.na(admission), "unknown", admission),
    admission = factor(admission),
    rating  = tolower(rating),
    rating = ifelse(rating == "insufficient evidence", NA, rating),
    rating = factor(
      rating,
      levels = c(
        "outstanding",
        "good",
        "requires improvement",
        "inadequate",
        "serious weaknesses",
        "special measures"
      ),
      ordered = TRUE
    ),
    inspection = as.Date(inspection, "%d-%m-%Y")
  ) %>%
  mutate_at(vars(starts_with("age_")), as.integer)

use_data(schools, overwrite = TRUE)
use_data(local_authority, overwrite = TRUE)
