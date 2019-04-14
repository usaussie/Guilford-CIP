library(siverse)
library(tidyverse)
library(googlesheets)
library(leaflet)
library(billboarder)
library(plotly)
library(scales)

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





 