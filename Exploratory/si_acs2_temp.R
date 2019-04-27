library(tidyverse)
library(tidycensus)

census_api_key("0cdac4dbbd32b4e4874b79ce6e8fee07d12a7b3a")

# Jon's code for cleaning ACS data

# acsvars <- load_variables(2017, "acs5", cache = T) %>%
#   mutate(level = str_count(label, pattern = "!!")) %>%
#   rowwise() %>%
#   mutate(levlab = str_split(label, pattern = "!!") %>% unlist() %>% .[level + 1]) %>%
#   ungroup() %>%
#   mutate(concept = str_to_title(concept)) %>%
#   rename(variable = name)

acsvars2 <- bind_rows(acs1 = load_variables(2017, "acs1", cache = T),
                      acs5 = load_variables(2017, "acs5", cache = T),
                      .id = "dataset") %>%
  add_column(year = 2017) %>% #to do: don't hardcode year
  mutate(level = str_count(label, pattern = "!!")) %>%
  rowwise() %>%
  mutate(levlab = str_split(label, pattern = "!!") %>% unlist() %>% .[level + 1]) %>%
  ungroup() %>%
  mutate(concept = str_to_title(concept)) %>%
  rename(variable = name) %>%
  separate(col = variable, into = c("table", "row"), sep = "_", remove = F) %>%
  group_by(year, dataset, table) %>%
  mutate(label_lead = lead(label)) %>%
  mutate(is_summary = str_detect(label_lead, label) & !is.na(label_lead)) %>%
  ungroup() %>%
  select(-label_lead)




test <- bind_rows(acs1 = load_variables(2017, "acs1", cache = T),
          acs5 = load_variables(2017, "acs5", cache = T),
          .id = "dataset") %>%
  add_column(year = 2017) %>% #to do: don't hardcode year
  mutate(level = str_count(label, pattern = "!!")) %>%
  rowwise() %>%
  mutate(levlab = str_split(label, pattern = "!!") %>% unlist() %>% .[level + 1]) %>% 
  ungroup() %>%
  mutate(concept = str_to_title(concept)) %>%
  rename(variable = name) %>%
  separate(col = variable, into = c("table", "row"), sep = "_", remove = F) %>%
  group_by(year, dataset, table) %>%
  mutate(label_lead = lead(label)) %>%
  mutate(is_summary = str_detect(label_lead, label )& !is.na(label_lead)) %>%
  ungroup() %>%
  select(-label_lead)


si_acs2 <- function(table, geography = "county", county = NULL, state = NULL, summary_var = "universe total", survey = "acs5", year = 2017, discard_summary_rows = TRUE) {

  acsvars <- acsvars2 %>% filter(dataset == survey, year == year)

  if(summary_var == "universe total") summary_var = paste0(table, "_001")
  summary_label = acsvars %>% filter(variable == summary_var) %>% pull(levlab)

  df <- get_acs(geography = geography,
                table = table,
                county = county,
                state = state,
                output = "tidy",
                year = 2017,
                cache_table = T,
                summary_var = summary_var,
                survey = survey) %>%
    clean_names() %>%
    left_join(acsvars) %>%
  select(-summary_moe) %>%
  select(geoid, geo_name = name, level, levlab, estimate, everything()) %>%
  rename(!!summary_label := summary_est)

if(discard_summary_rows) {
  df <- df %>%
    filter(!is_summary)
  message("Dropping summary rows.  To keep, run this function with `discard_summary_rows = FALSE`")
}

return(df)
}


x %>%
  distinct(label) %>%
  separate(label, into = as.character(1:7), sep = "!!", fill = "right") %>% gather(key = "level", value = "value")



# Rule: next column must be NA.  Must not have additional rows with non-na next columns

acsvars %>%
  filter(str_detect(variable, "B23002A")) %>%
  separate(col = variable, into = c("table", "row"), sep = "_", remove = F) %>%
  mutate(label_lead = lead(label)) %>%
  mutate(is_summary = str_detect(label_lead, label) & !is.na(label_lead)) %>%
  select(label_lead, label, is_summary)
