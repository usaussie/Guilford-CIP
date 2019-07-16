require(tidyverse)
require(siverse)
require(googleway)
require(leaflet)
require(leaflet.extras)
options(warnPartialMatchArgs = F)

# Functions -------------------------------------------------------------------------------------------------------

read_excel_twoheaders <- function(path) {
  merged_names <- suppressMessages(read_excel(path, col_names = F)) %>%
    slice(1:2) %>%
    rownames_to_column %>%
    gather(var, value, -rowname) %>%
    spread(rowname, value) %>%
    fill(`1`, .direction = "down") %>%
    mutate(merged_name = paste(`1`, `2`, sep = "_"),
           merged_name = str_remove(merged_name, "_NA$"),
           merged_name = make_clean_names(merged_name)) %>%
    pull(merged_name)

  read_excel(path, col_names = merged_names) %>%
    slice(-1:-2) %>%
    mutate_if(funs(Hmisc::all.is.numeric(., extras = c(".", "NA", NA, NA_character_))), as.numeric)
}


# Load Data -------------------------------------------------------------------------------------------------------

#NOTE: FOR ALL YEAR VALUES WE ARE USING THE END OF SCHOOL YEAR.  2017-2018 School Year = 2018

grd3_read <- read_excel("/Volumes/GoogleDrive/My Drive/SI/DataScience/data/Guilford County CIP/GCS Indicators/GCS Grade 3 EOG Reading Proficiency.xlsx") %>%
  clean_names() %>%
  fill(school, .direction = "down") %>% #deal with merged cells
  filter(school != "Guilford County Schools") %>% #remove county average
  filter(!is.na(year)) %>%
  replace_with_na(replace = list(reading_eog_3 = "NA")) %>%
  mutate(year = as.numeric(year),
         reading_eog_3 = as.numeric(reading_eog_3)) %>%
  rename(value = reading_eog_3)

kdib <- read_excel_twoheaders("/Volumes/GoogleDrive/My Drive/SI/DataScience/data/Guilford County CIP/GCS Indicators/GCS Kindergarten DIBELS BOY by School 2017-18 & 2018-19.xlsx") %>%
  rename(school = school_name) %>%
  filter(!is.na(gcs_school_code)) %>% #get rid of the 2nd header row and the county average
  select(-gcs_school_code) %>%
  gather(key = year, value = value, -school) %>%
  replace_with_na(replace = list(value = "*")) %>%
  mutate(year = parse_number(year) + 1,
         value = as.numeric(value))

hsgrad <- read_excel_twoheaders("/Volumes/GoogleDrive/My Drive/SI/DataScience/data/Guilford County CIP/GCS Indicators/GCS Graduation Rates By School Over Time.xlsx") %>%
  filter(code != "LEA") %>% #remove county average
  select(-contains("rate_change"), -contains("number_students_in_cohort"), -code) %>%
  gather(key = year, value = value, -school) %>%
  mutate(year = parse_number(year))


act <- read_excel("/Volumes/GoogleDrive/My Drive/SI/DataScience/data/Guilford County CIP/GCS Indicators/GCS Grade 11 ACT Performance Over Time.xlsx") %>%
  clean_names() %>%
  rename(year = reporting_year) %>%
  mutate(act_proficiency = parse_number(act_proficiency)) %>% #has values of ">95".  This makes them "95"
  rename(value = act_proficiency)

post_hs_enrolled <- read_excel_twoheaders("/Volumes/GoogleDrive/My Drive/SI/DataScience/data/Guilford County CIP/GCS Indicators/GCS Student Clearinghouse Information By School & District May 2019.xlsx") %>%
  filter(school != "GUILFORD COUNTY SCHOOLS") %>%
  select(school, contains("1st_year_after")) %>% #Decision point to use first year rather than fall after HS
  gather(key = year, value = value, -school) %>%
  mutate(year = parse_number(year))

gcs <- lst(post_hs_enrolled, act, hsgrad, kdib, grd3_read) %>%
  bind_rows(.id = "metric") %>%
  mutate(school = str_squish(school))

# # Geocode ---------------------------------------------------------------------------------------------------------

gcs <- gcs %>%
  distinct(school) %>%
  mutate(place = map(school,
                     function(school) {
                       google_geocode(address = paste0(school, ", Guilford County, North Carolina")) %>%
                         geocode_coordinates() %>%
                         slice(1) #Just keep the first in case there are multiple results.  This is prone to errors because it isn't based on any ranking.
                       }
                     )) %>%
  unnest(place) %>%
  right_join(gcs)

write_rds(gcs, "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/gcs.rds")
