library(siverse)
library(tidyverse)
library(googlesheets)
library(leaflet)
library(billboarder)
library(plotly)
library(scales)
library(tidycensus)
library(crayon)




acsvars <- load_variables(2017, "acs1", cache = T) %>%
  mutate(level = str_count(label, pattern = "!!")) %>%
  rowwise() %>%
  mutate(levlab = str_split(label, pattern = "!!") %>% unlist() %>% .[level + 1]) %>%
  ungroup() %>%
  mutate(concept = str_to_title(concept)) %>%
  dplyr::rename(variable = name)


si_acs <- function(table, county = NULL, state = NULL, summary_var = "universe total", geography = NULL, survey = NULL) {
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
          geometry = FALSE, 
          cb = FALSE, 
          survey = survey) %>%
    clean_names() %>%
    left_join(acsvars) %>%
    select(-summary_moe, -variable) %>%
    select(geoid, county = name, level, levlab, estimate, everything()) %>%
    rename(!!summary_label := summary_est)
}




# A White alone 
# B Black or African American Alone
# C American Indian and Alaska Native Alone
# D Asian Alone
# E Native Hawaiian and Other Pacific Islander Alone
# F Some Other Race Alone
# G Two or More Races
# H White Alone, Not Hispanic or Latino 
# I Hispanic or Latino 


# Per capita income by race ------------------------------------------------------

pc_df <- lst()

for(letter in c("A", "B", "C", "D", "E", "F", "G", "H", "I")) {
  tablenum <- paste0("B19301", letter)
  
  df_temp <- si_acs(tablenum, geography = "county", state = "NC", county  = "Guilford County", survey = "acs1") %>% 
    select(county, estimate, label, level) %>% 
    mutate(race = letter) 
  
  pc_df[[letter]] <- df_temp
}


pc_income <- bind_rows(pc_df)

pc_income <- pc_income %>% 
  mutate(race = case_when(race == "A" ~ "White alone",
                          race == "B"~ "Black or African American Alone",
                          race == "C" ~ "American Indian and Alaska Native Alone",
                          race == "D" ~ "Asian Alone",
                          race == "E" ~ "Native Hawaiian and Other Pacific Islander Alone",
                          race == "F" ~ "Some Other Race Alone",
                          race == "G" ~ "Two or More Races",
                          race == "H" ~ "White Alone, Not Hispanic or Latino", 
                          race == "I" ~ "Hispanic or Latino"))

pc_income_race <- pc_income %>% 
  filter(race!="White Alone, Not Hispanic or Latino") %>% 
  filter(race!="Hispanic or Latino") %>% 
  select(race, estimate)

billboarder() %>% 
  bb_barchart(data = pc_income_race)


pc_income_ethn <- pc_income %>% 
  filter(race=="White Alone, Not Hispanic or Latino"| race =="Hispanic or Latino" ) %>% 
  select(race, estimate)

billboarder() %>% 
  bb_barchart(data = pc_income_ethn)

save(pc_income, file = "G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/pc_income.rda")




