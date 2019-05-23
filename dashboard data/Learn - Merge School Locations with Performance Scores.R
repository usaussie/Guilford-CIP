require(tidyverse)
require(siverse)

spg <- read_rds("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data/spg.rds")
schools <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/schools.rds")




spg %>%
  filter(district_name == "Guilford County Schools") %>%
  left_join(schools %>%
              filter(str_detect(name, fixed("school", ignore_case = T))) %>%
              arrange(name) %>%
              mutate(school_name = str_remove(name, " School$")))
