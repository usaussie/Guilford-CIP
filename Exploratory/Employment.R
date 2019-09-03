library(siverse)
library(tidyverse)
library(googlesheets)
library(leaflet)
library(billboarder)
library(plotly)
library(scales)
library(tidycensus)
library(crayon)

employ <- get(load("G:/My Drive/ACS/2017 5-year/acs_employ_femchild_lst.RData"))
edu <- get(load("G:/My Drive/ACS/2017 5-year/acs_educ_over25years_lst.RData"))
eth <- get(load("G:/My Drive/ACS/2017 5-year/acs_ethnicity_lst.RData"))
house <- get(load("G:/My Drive/ACS/2017 5-year/acs_snap_households_childunder18_lst.RData"))
pov <- get(load("G:/My Drive/ACS/2017 5-year/acs_povrace_lst.RData"))

view(employ$county)
view(employ$place)
view(employ$reservation)
view(employ$state)

employedState <- employ$state %>% 
  filter(!is.na(employed)) %>% 
  filter(state == "NC") %>%
  filter(has_children != "Total") %>% 
  select(state) %>% 
  view()

employ$place %>% 
  View()

employedPlace <- employ$place %>% 
  filter(child_age == "Under.6.years.only", !is.na(labor_force), value_type == "estimate.B23003") %>% 
  select(city, county, state, labor_force, mil_civ, employed, value) %>% 
  filter(!(labor_force == "In.labor.force" & is.na(mil_civ))) %>% 
  filter(!(labor_force == "In.labor.force" & mil_civ == "Civilian" & is.na(employed))) %>% 
  filter(str_detect(county, "Guilford")) %>% 
  arrange(labor_force, mil_civ) %>% 
  mutate(value = as.numeric(value)) %>% 
  unite("employment", c("labor_force", "mil_civ", "employed" )) %>% 
  mutate(employment = str_replace_all(string = employment, pattern = "NA", replacement = "")) %>% 
  mutate(employment = str_replace_all(string = employment, pattern = "_", replacement = " ")) %>% 
  select(city, employment, value) %>% 
  spread(employment, value) 
  
billboarder() %>% 
  bb_barchart(data = employedPlace)

employedCounty <- employ$county %>% 
  filter(child_age == "Under.6.years.only", !is.na(labor_force), value_type == "estimate.B23003") %>% 
  select(county, state, labor_force, mil_civ, employed, value) %>% 
  filter(!(labor_force == "In.labor.force" & is.na(mil_civ))) %>% 
  filter(!(labor_force == "In.labor.force" & mil_civ == "Civilian" & is.na(employed))) %>% 
  filter(county == "Guilford County") %>% 
  arrange(labor_force, mil_civ) %>% 
  mutate(value = as.numeric(value)) %>% 
  unite("employment", c("labor_force", "mil_civ", "employed" )) 

x = employedCounty$employment
y = employedCounty$value
countyData <- data.frame(employedCounty$employment, employedCounty$value)
pCount <- plot_ly(data = countyData, x = ~employedCounty$employment, y = ~employedCounty$value,
            type = 'bar', text = y, textposition = 'auto',
            marker = list(color = 'rgb(158,202,225)',
                          line = list(color = 'rgb(8,48,107)', width = 1.5))) %>%
         layout(title = "Employment in Guilford County, North Carolina",
         barmode = 'group',
         xaxis = list(title = "Labor Status"),
         yaxis = list(title = "Value"))
pCount




# Employment by race ------------------------------------------------------

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


#si_acs("B23002I", geography = "county", state = "UT", survey = "acs1")

# A White alone 
# B Black or African American Alone
# C American Indian and Alaska Native Alone
# D Asian Alone
# E Native Hawaiian and Other Pacific Islander Alone
# F Some Other Race Alone
# G Two or More Races
# H White Alone, Not Hispanic or Latino 
# I Hispanic or Latino 


emp_df <- lst()
  
for(letter in c("A", "B", "C", "D", "E", "F", "G", "H", "I")) {
    tablenum <- paste0("B23002", letter)
    
    df_temp <- si_acs(tablenum, geography = "county", state = "NC", county  = "Guilford County", survey = "acs1") %>% 
      select(county, estimate, label, level) %>% 
      mutate(race = letter) 
    
    emp_df[[letter]] <- df_temp
}


emp_race <- bind_rows(emp_df)

emp_race <- emp_race %>% 
  mutate(race = case_when(race == "A" ~ "White alone",
                          race == "B"~ "Black or African American Alone",
                          race == "C" ~ "American Indian and Alaska Native Alone",
                          race == "D" ~ "Asian Alone",
                          race == "E" ~ "Native Hawaiian and Other Pacific Islander Alone",
                          race == "F" ~ "Some Other Race Alone",
                          race == "G" ~ "Two or More Races",
                          race == "H" ~ "White Alone, Not Hispanic or Latino", 
                          race == "I" ~ "Hispanic or Latino")) %>% 
  filter(race == "White alone"|race == "Black or African American Alone") %>% 
  filter(!is.na(estimate)) %>% 
  filter(str_detect(label, "Civilian")|str_detect(label,"Employed")|str_detect(label, "65 to 69")|str_detect(label, "70 years")) %>% 
  filter(!str_detect(label, "Unemployed")) %>% 
  filter(!str_detect(label, "Not in labor")) %>% 
  separate(label, c("l1", "l2", "l3", "l4", "l5", "l6", "l7"), sep = "!!", remove = FALSE) %>% 
  rename(sex = l3,
         ages = l4,
         laborforce = l5,
         civ_staus = l6,
         emp_status = l7) %>% 
  select(-l1, -l2) %>% 
  unite(sex_race, c(sex, race)) %>% 
   mutate(emp_status = case_when(civ_staus == "Employed"~ "Employed", 
                                TRUE~emp_status)) %>% 
  mutate(laborforce = case_when(str_detect(ages, "65")|str_detect(ages, "70")~"In labor force",
                                TRUE~laborforce)) %>% 
  filter(!is.na(laborforce))  %>% 
  filter(!(str_detect(ages, "70")&level ==4)) %>% 
  filter(!(str_detect(ages, "65")&level ==4)) %>%
  select(-civ_staus) %>% 
  group_by(ages, sex_race) %>% 
  arrange(emp_status, .by_group = TRUE) %>% 
  mutate(perc = round(estimate/lead(estimate)*100),0) %>% 
  ungroup() %>% 
  filter(!is.na(perc)) %>% 
  select(sex_race, perc, ages) %>% 
  spread(sex_race, perc) 

#save(emp_race, file = "G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/emp_race.rda")

load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/emp_race.rda")

emp_race <- emp_race %>% 
  rename(`Female: Black or African American Alone` = `Female_Black or African American Alone`, 
         `Female: White Alone` = `Female_White alone`,
         `Male: Black or African American Alone` = `Male_Black or African American Alone`,
         `Male: White alone` = `Male_White alone`)

save(emp_race, file = "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/emp_race.rda")

billboarder() %>% 
  bb_barchart(data = emp_race)
 











 