require(tidyverse)
require(siverse)


dr <- read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_records_test.csv", guess_max = 553841) %>%
  clean_names() %>%
  remove_empty(which = "cols")

dr %>%
  count(icd_title, sort = T)

dr %>% count(zipcode)

dr %>% count(cityrestext)

# x <- names(dr) %>%
#   map(~count(dr, !!sym(.x), sort = T))

dr %>%
  count(cityc)

range(dr$dod_yr)




