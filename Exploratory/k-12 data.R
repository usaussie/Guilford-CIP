require(tidyverse)
require(siverse)


# State, District, and School Level End-of-Course and End-of-Grade Achievement Level Report  ----------------------

tests <- dir_ls(path_expand("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data"), glob = "*testresults.xlsx") %>%
  map(~read_excel(.x, skip = 6) %>%
        add_column(year = parse_number(basename(.x))) %>%
        clean_names()
      ) %>%
  bind_rows() %>%
  gather(key = percent_group, value = percent, contains("percent")) %>%
  replace_with_na(list(percent = "*")) %>%
  mutate(yearnum_start = as.numeric(str_sub(year, 1, 2))) %>%
  mutate(percent = parse_number(percent)) #change <5 to 5 and >095 to 95


tests %>%
  filter(district_name == "Guilford County Schools") %>%
  filter(percent_group == "percent_level_1") %>%
  ggplot(aes(x = yearnum_start, y = percent)) + #facet_wrap(~percent_group) +
  geom_point() + geom_smooth() + guides(fill = F, color = F)




# School performance grade ----------------------------------------------------------------------------------------
spg <- bind_rows(
  read_excel(path_expand("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data/spg1314.xlsx"), skip = 3) %>%
    add_column(year = 1314) %>%
    clean_names() %>%
    rename(district_name = lea_name,
           state_board_region = sbe_region),

  read_excel(path_expand("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data/spg1415.xlsx"), skip = 7) %>%
    add_column(year = 1415) %>%
    clean_names() %>%
    rename(district_name = lea_name,
           state_board_region = sbe_district),

  read_excel(path_expand("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data/spg1516.xlsx"), skip = 6) %>%
    add_column(year = 1516) %>%
    clean_names(),

  read_excel(path_expand("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data/spg1617.xlsx"), skip = 6) %>%
    add_column(year = 1617) %>%
    clean_names() %>%
    rename(state_board_region = sbe_district)
)

spg <- spg %>%
  mutate(state_board_region = str_remove(state_board_region, " Region"),
         state_board_region = str_replace(state_board_region, "-", " "))

spg <- spg %>%
  filter(district_name == "Guilford County Schools")

spg %>%
  count(year, spg_grade) %>%
  ggplot(aes)
