# This file contains data from the Piedmont Health Caounts dashboard

library(tidyverse)
library(zoo)



# Food insecurity ---------------------------------------------------------

# From http://www.piedmonthealthcounts.org/indicators/index/view?indicatorId=2107&localeId=1982&localeChartIdxs=1

# Download data into a csv and save it in the folder Web Sources (within Updated data)

food_insecurity <- read_csv("./Updated data/Web Sources/food_insecurity.csv") %>% clean_names() %>% 
  filter(location == "Guilford") %>%
  select(indicator_value, period_of_measure)

save(food_insecurity, file = "./Updated data/food_insecurity.rda")


# Infant Mortality Rate ---------------------------------------------------

# From http://www.piedmonthealthcounts.org/indicators/index/view?indicatorId=289&localeTypeId=2

# Download data into a csv and save it in the folder Web Sources (within Updated data)

imr <- read_csv("./Updated data/Web Sources/infant_mortality_rate.csv") %>% clean_names()

imr <- imr %>% 
  filter(location == "Guilford", period_of_measure=="2013-2017") %>% 
  select(indicator_value, breakout_subcategory, breakout_value) %>% 
  add_row(breakout_subcategory = "All") %>% 
  mutate(breakout_value = case_when(breakout_subcategory == "All"~na.locf(indicator_value),
                                    TRUE~breakout_value)) %>% 
  select(category = breakout_subcategory, value = breakout_value) %>% 
  mutate(category = str_remove(category, ", non-Hispanic")) %>% 
  rowid_to_column() %>% 
  arrange(desc(rowid)) %>% 
  select(-rowid)

save(imr, file = "./Updated data/Web Sources/imr.rda")


# Diabetes ----------------------------------------------------------------

# From http://www.piedmonthealthcounts.org/indicators/index/view?indicatorId=40&localeTypeId=2&periodId=271&comparisonId=927

# Download data into a csv and save it in the folder Web Sources (within Updated data)

diabetes <- read_csv("./Updated data/Web Sources/diabetes.csv") %>% clean_names()

diabetes <- diabetes %>% 
  filter(location == "Guilford") %>% 
  arrange(desc(period_of_measure)) %>% 
  slice(1) %>% 
  select(location, indicator_value, period_of_measure)


print(diabetes %>% pull(indicator_value)) # number for inforgraphic

print(diabetes %>% pull(period_of_measure)) #year of data








