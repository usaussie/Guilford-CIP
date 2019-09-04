require(tidyverse)
require(leaflet)
require(tidycensus)
require(sf)
require(janitor)


# si_acs fn ---------------------------------------------------------------

acsvars <- load_variables(2017, "acs1", cache = T) %>%
  mutate(level = str_count(label, pattern = "!!")) %>%
  rowwise() %>%
  mutate(levlab = str_split(label, pattern = "!!") %>% unlist() %>% .[level + 1]) %>%
  ungroup() %>%
  mutate(concept = str_to_title(concept)) %>%
  rename(variable = name)

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




# Data pulls --------------------------------------------------------------
pop_age_gc <- si_acs("B01001", county = "Guilford County", state = "NC", geography = "county", survey = "acs1")

pop_age_cities <- si_acs("B01001", geography = "place", state = "NC",  survey = "acs1") %>% 
  filter(str_detect(county, "Greens")|str_detect(county, "High"))

pop_age <- bind_rows(pop_age_gc, pop_age_cities)

med_age_gc <- si_acs("B01002", geography = "county", state = "NC", survey = "acs1", county = "Guilford County")

med_age_cities <- si_acs("B01002", geography = "place", state = "NC",  survey = "acs1")%>% 
  filter(str_detect(county, "Greens")|str_detect(county, "High"))

med_age <- bind_rows(med_age_gc, med_age_cities)

# Infographics ------------------------------------------------------------

tot_pop_guilford <- pop_age %>% 
  filter(level==1, str_detect(county, "Guilford")) %>% 
  pull(estimate)

tot_pop_greensboro <- pop_age %>% 
  filter(level==1, str_detect(county, "Greens")) %>% 
  pull(estimate)

tot_pop_highpoint <- pop_age %>% 
  filter(level==1, str_detect(county, "High")) %>% 
  pull(estimate)

med_age_guilford <- med_age %>% 
  filter(levlab=="Total", str_detect(county, "Guilford")) %>% 
  pull(estimate)

med_age_greensboro <- med_age %>% 
  filter(levlab=="Total", str_detect(county, "Greens")) %>% 
  pull(estimate)

med_age_highpoint <- med_age %>% 
  filter(levlab=="Total", str_detect(county, "High")) %>% 
  pull(estimate)


# Age Distribution --------------------------------------------------------


ages <- pop_age %>%  filter(level ==3) %>% 
  select(levlab, estimate, label, county) %>% 
  group_by(county, levlab) %>% 
  summarise(total = sum(estimate)) %>% 
  spread(levlab, total) %>% 
  mutate(`0-9 Years` = sum(`Under 5 years`,`5 to 9 years` ),
         `10-19 Years` = sum(`10 to 14 years`, `15 to 17 years`, `18 and 19 years` ), 
         `20-29 Years` = sum(`20 years`, `21 years`, `22 to 24 years`, `25 to 29 years`),
         `30-39 Years` = sum(`30 to 34 years`, `35 to 39 years`), 
         `40-49 Years` = sum(`40 to 44 years`, `45 to 49 years`), 
         `50-59 Years` = sum(`50 to 54 years`, `55 to 59 years`),
         `60-69 Years`= sum(`60 and 61 years`, `62 to 64 years`, `65 and 66 years`, `67 to 69 years`),
         `70 - 79 Years` = sum(`70 to 74 years`, `75 to 79 years`), 
         `80 Years and Over` = sum(`80 to 84 years`, `85 years and over`)) %>% 
  select(county, contains("Years", ignore.case = F)) %>% 
  gather(c(2:10), key = "Ages", value = "Total") %>% 
  mutate(denom = sum(Total),
         perc = round((Total/denom)*100),0,
         location = str_remove(county, ", North Carolina")) %>% 
  ungroup() %>% 
  select(Ages, perc, location) 
  
save(ages, file = "./Updated data/ages.rda")


# Sex ---------------------------------------------------------------------

sex <- pop_age %>% 
  filter(level == 2) %>% 
  select(levlab, estimate, location = county) %>% 
  mutate(location = str_remove(location, ", North Carolina"))

save(sex, file = "./Updated data/sex.rda")


# Race --------------------------------------------------------------------




# Ethnicity ---------------------------------------------------------------


