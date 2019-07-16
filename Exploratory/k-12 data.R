require(tidyverse)
require(siverse)

### ALL DATA DOWNLOADED MANUALLY FROM http://www.ncpublicschools.org/accountability/reporting/

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


#NOTE THAT PER A CALL WITH CURTIS SONNEMAN @ NC Dept of Public Instruction ( 919-807-3877), the 13-14 data matches up to the years beyond where the row is "College and Career Ready".  HOWEVER, THIS WILL NOT BE THE CASE for the next year (ie 18-19!)

dd <- dd %>%
  mutate(standard_ccr_level_4_5_glp_level_3_above = ifelse(year == 13, "College and Career Ready", standard_ccr_level_4_5_glp_level_3_above)) %>%
  mutate(subject = str_remove(subject, " \\(Standard 4 year\\)"))

#Abbreviations: http://www.ncpublicschools.org/docs/accountability/reporting/readywebsiteabbreviations1213.pdf
# AIG Academically or Intellectually Gifted
# EDS Economically Disadvantaged Students
# LEP Limited English Proficient
# SWD Students With Disabilities
# AMIN American Indian
# ASIAN Asian
# BLACK Black
# HISP Hispanic
# >=2RACES Two or More Races
# WHITE White
# MALE Male
# FEMALE Female
# ALLSGRP All Subgroups

# Experimental:
dd %>%
  filter(school_name == "Guilford County Schools") %>%
  filter(standard_ccr_level_4_5_glp_level_3_above == "College and Career Ready" | standard_ccr_level_4_5_glp_level_3_above == "Standard (4 Year)" | standard_ccr_level_4_5_glp_level_3_above == "Met UNC Minimum") %>%
  select(-starts_with("num_")) %>%
  gather(key = "group", value = "percent", starts_with("percent_")) %>%
  mutate(percent = parse_number(percent)) %>%
  filter(subject %in% c("All EOG/EOC Subjects", "All EOC Subjects", "All EOG Subjects", "Graduation Rate", "The ACT - Composite Score")) %>%
  ggplot(aes(x = year, y = percent, color = group, fill = group)) +
    geom_point() + geom_line() +
    facet_wrap(~subject)















