require(tidyverse)
require(siverse)

dr <- read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_records_test.csv", col_types = cols(.default = "c")) %>%
  mutate_if(funs(all.is.numeric(., extras = c(".", "NA", NA, NA_character_))), as.numeric)

  clean_names()

  dr <- read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_records_test.csv", guess_max = Inf)
