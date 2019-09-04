require(tidyverse)
require(leaflet)
require(tidycensus)
require(sf)
require(janitor)
library(crayon)

# ACS Tables: 
# ACS B25006
# ACS B25003(A-G)
# ACS B25002
# ACS B22003


# si_acs fn ---------------------------------------------------------------

acsvars <- load_variables(2017, "acs5", cache = T) %>%
  mutate(level = str_count(label, pattern = "!!")) %>%
  rowwise() %>%
  mutate(levlab = str_split(label, pattern = "!!") %>% unlist() %>% .[level + 1]) %>%
  ungroup() %>%
  mutate(concept = str_to_title(concept)) %>%
  rename(variable = name)


si_acs <- function(table, county = NULL, state = NULL, summary_var = "universe total", geography = NULL, survey = "acs5", geometry = FALSE) {
  cat(yellow(bold("Reminder: You must stay within the same level for any summary to be valid!\n")))
  
  if(summary_var == "universe total") summary_var = paste0(table, "_001")
  summary_label = acsvars %>% filter(variable == summary_var) %>% pull(levlab)
  
  get_acs(geography = geography,
          table = table,
          county = county,
          state = state,
          output = "tidy",
          year = 2017,
          cache_table = T,
          summary_var = summary_var, 
          geometry = geometry, 
          cb = T, 
          survey = survey) %>%
    clean_names() %>%
    left_join(acsvars) %>%
    select(-summary_moe, -variable) %>%
    select(geoid, county = name, level, levlab, estimate, everything()) %>%
    rename(!!summary_label := summary_est)
}


# Race of householder  ----------------------------------------------------

hh_race <- si_acs("B25006", state = "NC", geography = "county", county = "Guilford County", survey = "acs1") %>% 
  select(-moe) %>% 
  filter(level!=3) %>% 
  filter(level!=1) %>% 
  mutate(levlab =  str_remove(levlab, "Householder who is ")) %>% 
  select(location = county,levlab, estimate)

save(hh_race, file = "./Updated data/hh_race.rda")



# Owned vs Rented Homes ---------------------------------------------------


tenure_df <- lst()

for(letter in c("A", "B", "C", "D", "E", "F", "G", "H", "I")) {
  tablenum <- paste0("B25003", letter)
  
  df_temp <- si_acs(tablenum, geography = "county", state = "NC", county  = "Guilford County", survey = "acs1") %>% 
    select(county, estimate, label, level, Total) %>% 
    mutate(race = letter) 
  
  tenure_df[[letter]] <- df_temp
}


tenure_gc <- bind_rows(tenure_df)

tenure_gc <- tenure_gc %>% 
  filter(level!=1) %>% 
  mutate(race = case_when(race == "A" ~ "White alone",
                          race == "B"~ "Black or African American Alone",
                          race == "C" ~ "American Indian and Alaska Native Alone",
                          race == "D" ~ "Asian Alone",
                          race == "E" ~ "Native Hawaiian and Other Pacific Islander Alone",
                          race == "F" ~ "Some Other Race Alone",
                          race == "G" ~ "Two or More Races",
                          race == "H" ~ "White Alone, Not Hispanic or Latino", 
                          race == "I" ~ "Hispanic or Latino")) %>% 
  rename(location = county) %>% 
  filter(!str_detect(race, "Hispanic")) %>% 
  filter(!is.na(Total)) %>% 
  mutate(perc = estimate/Total) %>% 
  mutate(tenure = case_when(str_detect(label, "Owner") ~ "Owner",
                            str_detect(label, "Renter")~"Renter")) %>% 
  mutate(location = str_remove(location, ", North Carolina")) %>% 
  select(race, perc, tenure)


save(tenure_gc, file = "./Updated data/tenure_gc.rda")


# Vacant Homes Map --------------------------------------------------------

vacant_housing <- si_acs("B25002", geography = "tract", state = "NC", geometry = T, county = "Guilford County")%>% rename(GEOID = geoid) %>% filter(levlab == "Vacant")

save(vacant_housing, file = "./Updated data/vacant_housing.rda")


# Food Stamp Infographics -------------------------------------------------

snap_county <- si_acs("B22003",geography = "county", state = "NC", survey = "acs1", county = "Guilford County")

snap <- snap_county %>% 
  filter(level==2) %>% 
  filter(str_detect(label, "received Food")) %>% 
  mutate(perc = (estimate/Total)*100) %>% 
  pull(perc) 

print(snap)  










