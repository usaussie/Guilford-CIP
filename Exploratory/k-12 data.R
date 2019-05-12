require(tidyverse)
require(siverse)


# State, District, and School Level End-of-Course and End-of-Grade Achievement Level Report  ----------------------

test <- dir_ls(path_expand("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data"), glob = "*testresults.xlsx") %>%
  map(~read_excel(.x, skip = 6) %>% add_column(year = parse_number(basename(.x)))) %>%
  bind_rows() %>%
  clean_names()


