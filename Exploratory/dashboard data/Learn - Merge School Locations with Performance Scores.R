require(tidyverse)
require(siverse)
library(fuzzyjoin)

spg <- read_rds("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data/spg.rds")
schools <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/schools.rds")


spg %>%
  filter(district_name == "Guilford County Schools") %>%
  left_join(schools %>%
              filter(str_detect(name, fixed("school", ignore_case = T))) %>%
              arrange(name) %>%
              mutate(school_name = str_remove(name, " School$")))

#Actual Schools in Guilford County
guilford_schools <- spg %>% 
  filter(district_name == "Guilford County Schools") %>%
  distinct(school_name)

loc_schools <- schools %>%
  filter(str_detect(name, fixed("school", ignore_case = T))) %>%
  arrange(name) %>%
  mutate(school_name = str_remove(name, " School$"))
  
first_join<- guilford_schools %>% inner_join(loc_schools)

#Schools that didn't match
remaining1 <- anti_join(guilford_schools, fuz_join %>% rename(school_name = school_name.x)) 

#Fuzzy Match the remaining
fuz_join1<- remaining1 %>% stringdist_inner_join(loc_schools, by = c(school_name = "school_name"), max_dist =1)
#Fuzzy Join isn't giving me anything else. Have to rethink how to move forward with this




