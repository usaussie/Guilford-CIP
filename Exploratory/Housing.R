library(siverse)
library(tidyverse)
library(crayon)
library(tidycensus)

census_api_key("63183e84c8d31d2eaad041eb9300fe833b304630", install = TRUE)

acsvars <- load_variables(2017, "acs5", cache = TRUE) %>% 
  mutate(level = str_count(label, pattern = "!!")) %>% 
  rowwise() %>% 
  mutate(levlab = str_split(label, pattern = "!!") %>% unlist() %>% .[level + 1]) %>% 
  ungroup() %>% 
  mutate(concept = str_to_title(concept)) %>% 
  rename(variable = name)


acsvars <- get_acs(geography="county",
                   variables=)

si_acs <- function(table, county = NULL, state = NULL, summary_var = "universe total") {
  cat(yellow(bold("Reminder: You must stay within the same level for any summary to be valid!\n")))
  
  if(summary_var == "universe total") summary_var = paste0(table, "_001")
  summary_label = acsvars %>% filter(variable == summary_var) %>% pull(levlab) 
  
  get_acs(geography = "county", 
          table = table, 
          county = county,
          state = state,
          output = "tidy",
          year = 2017,
          cache_table = T,
          summary_var = summary_var) %>% 
    clean_names() %>% 
    left_join(acsvars) %>% 
    select(-summary_moe, -variable) %>% 
    select(geoid, county = name, level, levlab, estimate, everything()) %>% 
    rename(!!summary_label := summary_est)
}

structureType.original.state <- si_acs("B25024", state="NC")
structureType.filtered.state <- structureType.original.state %>% 
  filter(concept=="Units in Structure") %>% 
  filter(level == "2") %>% 
  select(county, levlab, estimate, moe, Total)



medianHousingValue.original.place <- si_acs("B25075") 
medianHousingValue.filtered.place <- medianHousingValue.original.place %>% 
  separate(col = county, into = c("county", "state"), sep = ",") %>% 
  filter(concept == "Value") %>% 
  filter(level == "2") %>% 
  select(county, state, levlab, estimate, moe)

medianHousingValue.original.state <- si_acs("B25075", state="NC") 
medianHousingValue.filtered.state <- medianHousingValue.original.state %>% 
  separate(col = county, into = c("county", "state"), sep = ",") %>% 
  filter(concept == "Value") %>% 
  filter(level =="2") %>% 
  select(county, levlab, estimate, moe)

######################## Median Housing Prices binned by State (Percentage)


###Having bug with making it a percentage
medianHousingValue.stateSplit <- medianHousingValue.filtered.place %>% 
  group_by(state, levlab) %>% 
  mutate(total=sum(estimate)) %>% 
  ungroup() %>% 
  group_by(state) %>% 
  mutate(estimate = (estimate/total)*100) %>% 
  select(levlab, estimate, state) %>% 
  spread(levlab, estimate)

billboarder() %>% 
  bb_barchart(data = medianHousingValue.stateSplit) %>% 
  bb_labs(title = "Median Housing Value Binned By State")


######################## Median Housing Prices binned by City (Percentage)
medianHousingValue.countySplit <- medianHousingValue.filtered.state %>% 
  group_by(county, levlab) %>% 
  summarise(total=sum(estimate)) %>% 
  ungroup() %>% 
  group_by(county) %>% 
  mutate(total1 = sum(total)) %>% 
  mutate(perc = (total/total1)*100) %>% 
  select(levlab, perc, county) %>% 
  spread(levlab, perc)

billboarder() %>% 
  bb_barchart(data = medianHousingValue.countySplit) %>% 
  bb_labs(title = "Median Housing Value Binned By County")

######################### Pie chart on Guilford housing distributions (Percentage)

medianHousingValue.countyDist <- medianHousingValue.filtered.state %>% 
  filter(county=="Guilford County, North Carolina") %>% 
  group_by(levlab) %>% 
  summarise(total=sum(estimate)) %>% 
  select(levlab, total) %>% 
  mutate(total = total/sum(total) * 100) %>% 
  mutate(total = round(total, digits=2))

pieGuilfordLabel <- paste(medianHousingValue.countyDist$levlab, medianHousingValue.countyDist$total) %>% 
  paste("%", sep="")

pie(medianHousingValue.countyDist$total, labels=pieGuilfordLabel, main = "Median Housing Value Distribution in Guilford")

#############################
  






