require(tidyverse)
require(siverse)

pm <- read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/fourMonthsPermitting.csv") %>%
  bind_rows(read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/fiveYearPermitting.csv"), .id = "source") %>%
  clean_names()

pm %>% count(apptype)

pm %>%
  filter(apptype == "Event") %>%
  View
