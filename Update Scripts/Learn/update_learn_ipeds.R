require(tidyverse)
require(ipeds)
require(janitor)

# Options ---------------------------------------------------------------------------------------------------------

survey_year <- 2018




# Download all surveys --------------------------------------------------------------------------------------------


download_ipeds(year = survey_year) #By default it looks for the year 1 previous to the current year. (ie now - 1).


# Get GEOID info --------------------------------------------------------------------------------------------------

hd <- ipeds_survey("HD", year = survey_year) %>%
  as_tibble() %>%
  clean_names() %>%
  filter(countycd == 37081)
# Entering class size ---------------------------------------------------------------------------------------------


efd <- ipeds_survey("EFD", year = survey_year) %>% as_tibble()

efd <- efd %>%
  select(unitid = UNITID,
         undergrad_entering = UGENTERN) %>%
  semi_join(hd)



select(Institution_Name, Sector, total_complete_avg, debt_to_earnings_ratio_best, full_time_retention_rate_mean, total_students_entering_2016)