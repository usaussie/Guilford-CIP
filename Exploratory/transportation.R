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



# Means of Transportation to Work  ----------------------------------------

# Table B08105: Means of Transportation to Work 

tr_df <- lst()

for(letter in c("A", "B", "C", "D", "E", "F", "G", "H", "I")) {
  tablenum <- paste0("B08105", letter)
  
  df_temp <- si_acs(tablenum, geography = "county", state = "NC", county  = "Guilford County", survey = "acs1") %>% 
    select(county, estimate, label, level, Total) %>% 
    mutate(race = letter) 
  
  tr_df[[letter]] <- df_temp
}


transp <- bind_rows(tr_df)

transp <- transp %>% 
  mutate(race = case_when(race == "A" ~ "White alone",
                          race == "B"~ "Black or African American Alone",
                          race == "C" ~ "American Indian and Alaska Native Alone",
                          race == "D" ~ "Asian Alone",
                          race == "E" ~ "Native Hawaiian and Other Pacific Islander Alone",
                          race == "F" ~ "Some Other Race Alone",
                          race == "G" ~ "Two or More Races",
                          race == "H" ~ "White Alone, Not Hispanic or Latino", 
                          race == "I" ~ "Hispanic or Latino"))

transp_race <- transp %>% 
  filter(level!=1) %>% 
  filter(race == "White alone"|race == "Black or African American Alone"|race == "Two or More Races") %>% 
  mutate(label = str_remove(label, "Estimate!!Total!!")) %>% 
  mutate(perc = round(estimate/Total*100,0)) %>% 
  select(race, label, perc) %>% 
  spread(race, perc)

billboarder() %>% 
  bb_barchart(data = transp_race) %>% 
  bb_bar(padding = 2)


transp_ethn <- transp %>% 
  filter(level!=1) %>% 
  filter(race == "White Alone, Not Hispanic or Latino"|race == "Hispanic or Latino") %>% 
  mutate(label = str_remove(label, "Estimate!!Total!!")) %>% 
  mutate(perc = round(estimate/Total*100,0)) %>% 
  select(race, label, perc) %>% 
  filter(perc!=0) %>% 
  spread(race, perc)
  
billboarder() %>% 
  bb_barchart(data = transp_ethn ) %>% 
  bb_bar(padding = 2)
