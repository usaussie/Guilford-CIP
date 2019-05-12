require(tidyverse)
require(siverse)


# State, District, and School Level End-of-Course and End-of-Grade Achievement Level Report  ----------------------

tests <- dir_ls(path_expand("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data"), glob = "*testresults.xlsx") %>%
  map(~read_excel(.x, skip = 6) %>%
        add_column(year = parse_number(basename(.x)))
      ) %>%
  bind_rows() %>%
  clean_names() %>%
  gather(key = percent_group, value = percent, contains("percent")) %>%
  mutate(percent_group = str_remove(percent_group, "_2$"),
         percent_group = case_when(percent_group == "percent_level" ~ "percent_level_2",
                                   TRUE ~ percent_group)) %>%
  replace_with_na(list(percent = "*")) %>%
  mutate(school_code = coalesce(school_code, school_code_2)) %>%
  select(-school_code_2) %>%
  mutate(yearnum_start = as.numeric(str_sub(year, 1, 2))) %>%
  mutate(percent = parse_number(percent)) #change <5 to 5 and >095 to 95


tests %>%
  filter(district_name == "Guilford County Schools") %>%
  filter(percent_group == "percent_level_1") %>%
  ggplot(aes(x = yearnum_start, y = percent)) + #facet_wrap(~percent_group) +
  geom_point() + geom_smooth() + guides(fill = F, color = F)
