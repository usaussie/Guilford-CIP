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
         state_board_region = str_replace(state_board_region, "-", " ")) %>%
  mutate(spg_score = as.numeric(spg_score))

spg <- spg %>%
  filter(district_name == "Guilford County Schools")

### Plots
spg %>%
  count(year, spg_grade) %>%
  ggplot(aes(x = year, y = n, color = spg_grade)) +
  geom_point() + geom_line()
  geom_col(position = "dodge")

spg %>%
  tabyl(year, spg_grade) %>%
  adorn_percentages() %>%
  adorn_totals("col") %>%
  adorn_pct_formatting()

spg %>%
  ggplot(aes(x = as.character(year), y = spg_score)) + geom_violin()


# Ready Drill Down ------------------------------------------------------------------------------------------------


dd <- dir_ls(path_expand("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data"), regexp = "/acct{0,1}drilldwn\\d{2}.xlsx") %>%
  map(function(file) {

    raw <- suppressMessages(read_excel(file, n_max = 20, col_types = "text")) #expect warnings

    header_rownum <- raw %>%
      mutate(rownum = row_number()) %>%
      filter_at(1, all_vars(str_detect(., "[Dd]istrict"))) %>%
      pull(rownum)

    header <- raw %>% slice(header_rownum) %>% gather(key = "row", value = "header")

    pre_header <- raw %>% slice(header_rownum - 1) %>% gather(key = "row", value = "pre_header")

    col_names <- left_join(pre_header, header, by = "row") %>%
      fill(pre_header) %>%
      mutate(pre_header = case_when(pre_header == "Percent" ~ "percent",
                                    pre_header == "Denominator" ~ "num",
                                    TRUE ~ NA_character_)) %>%
      unite(col = full_header, pre_header, header, na.rm = T) %>%
      pull(full_header)

    read_excel(file, skip = header_rownum + 1, col_names = col_names) %>%
        add_column(year = parse_number(basename(file))) %>%
        clean_names()
  }
  ) %>%
  bind_rows()


