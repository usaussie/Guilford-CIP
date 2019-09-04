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


# Graduation ------------------------------------------------------------------------------------------------------

gr <- ipeds_survey("GR", year = survey_year) %>%
  as_tibble() %>%
  clean_names() %>%
  semi_join(hd)

#From the frequencies tab of https://nces.ed.gov/ipeds/datacenter/data/GR2017_Dict.zip
grad_status_codes <- tribble(~var, ~code, ~descrip,
  "CHRTSTAT",  10, "Revised cohort",
  "CHRTSTAT",  11, "Exclusions",
  "CHRTSTAT",  12, "Adjusted cohort (revised cohort minus exclusions)",
  "CHRTSTAT",  13, "Completers within 150% of normal time",
  "CHRTSTAT",  14, "Completers of programs of less than 2 years (150% of normal time)",
  "CHRTSTAT",  15, "Completers of programs of 2 but less than 4 years (150% of normal time)",
  "CHRTSTAT",  16, "Completers of bachelor's or equivalent degrees (150% of normal time)",
  "CHRTSTAT",  17, "Completers of bachelor's or equivalent degrees in 4 years or less",
  "CHRTSTAT",  18, "Completers of bachelor's or equivalent degrees in 5 years",
  "CHRTSTAT",  19, "Completers of bachelor's or equivalent degrees in 6 years",
  "CHRTSTAT",  20, "Transfer-out students",
  "CHRTSTAT",  22, "Completers of programs within 100% of normal time total",
  "CHRTSTAT",  23, "Completers of programs of < 2 yrs within 100% of normal time (not available by race or gender)",
  "CHRTSTAT",  24, "Completers of programs of 2 but < 4 yrs within 100% of normal time (not available by race or gender)",
  "CHRTSTAT",  31, "Noncompleters, still enrolled",
  "CHRTSTAT",  32, "Noncompleters, no longer enrolled"
  )

cohort_data_codes <- tribble(~var, ~code, ~descrip,
                       "GRTYPE",  40, "Total exclusions 4-year schools",
                       "GRTYPE",   2, "4-year institutions, Adjusted cohort (revised cohort minus exclusions)",
                       "GRTYPE",   3, "4-year institutions, Completers within 150% of normal time",
                       "GRTYPE",   4, "4-year institutions, Transfer-out students",
                       "GRTYPE",  41, "4-year institutions, noncompleters still enrolled",
                       "GRTYPE",  42, "4-year institutions, No longer enrolled",
                       "GRTYPE",   6, "Bachelor's or equiv subcohort (4-yr institution)",
                       "GRTYPE",   7, "Bachelor's or equiv subcohort (4-yr institution) exclusions",
                       "GRTYPE",   8, "Bachelor's or equiv subcohort (4-yr institution) adjusted cohort (revised cohort minus exclusions)",
                       "GRTYPE",   9, "Bachelor's or equiv subcohort (4-yr institution) Completers within 150% of normal time total",
                       "GRTYPE",  10, "Bachelor's or equiv subcohort (4-yr institution) Completers of programs of < 2 yrs (150% of normal time)",
                       "GRTYPE",  11, "Bachelor's or equiv subcohort (4-yr institution) Completers of programs of 2 but <4 yrs (150% of normal time)",
                       "GRTYPE",  12, "Bachelor's or equiv subcohort (4-yr institution) Completers of bachelor's or equiv degrees total (150% of normal time)",
                       "GRTYPE",  13, "Bachelor's or equiv subcohort (4-yr institution) Completers of bachelor's or equiv degrees in 4 years or less",
                       "GRTYPE",  14, "Bachelor's or equiv subcohort (4-yr institution) Completers of bachelor's or equiv degrees in 5 years",
                       "GRTYPE",  15, "Bachelor's or equiv subcohort (4-yr institution) Completers of bachelor's or equiv degrees in 6 years",
                       "GRTYPE",  16, "Bachelor's or equiv subcohort (4-yr institution) Transfer-out students",
                       "GRTYPE",  43, "Bachelor's or equiv subcohort (4-yr institution) noncompleters still enrolled",
                       "GRTYPE",  44, "Bachelor's or equiv subcohort (4-yr institution), No longer enrolled",
                       "GRTYPE",  18, "Other degree/certif-seeking subcohort (4-yr institution)",
                       "GRTYPE",  19, "Other degree/certificate-seeking subcohort(4-yr institution) exclusions",
                       "GRTYPE",  20, "Other degree/certif-seeking subcohort (4-yr institution) Adjusted cohort (revised cohort minus exclusions)",
                       "GRTYPE",  21, "Other degree/certif-seeking subcohort (4-yr institution) Completers within 150% of normal time total",
                       "GRTYPE",  22, "Other degree/certif-seeking subcohort (4-yr institution) Completers of programs < 2 yrs (150% of normal time)",
                       "GRTYPE",  23, "Other degree/certif-seeking subcohort (4-yr institution) Completers of programs of 2 but < 4 yrs (150% of normal time)",
                       "GRTYPE",  24, "Other degree/certif-seeking subcohort (4-yr institution) Completers of bachelor's or equiv degrees (150% of normal time)",
                       "GRTYPE",  25, "Other degree/certif-seeking subcohort (4-yr institution) Transfer-out students",
                       "GRTYPE",  45, "Other degree/certif-seeking subcohort (4-yr institution) noncompleters still enrolled",
                       "GRTYPE",  46, "Other degree/certif-seeking subcohort (4-yr institution) No longer enrolled",
                       "GRTYPE",  27, "Degree/certif-seeking students ( 2-yr institution)",
                       "GRTYPE",  28, "Degree/certificate-seeking subcohort(2-yr institution) exclusions",
                       "GRTYPE",  29, "Degree/certif-seeking students ( 2-yr institution) Adjusted cohort (revised cohort minus exclusions)",
                       "GRTYPE",  30, "Degree/certif-seeking students ( 2-yr institution) Completers within 150% of normal time total",
                       "GRTYPE",  31, "Degree/certif-seeking students ( 2-yr institution) Completers of programs of < 2 yrs (150% of normal time)",
                       "GRTYPE",  32, "Degree/certificate-seeking students ( 2-yr institution) Completers of programs of 2 but < 4 yrs (150% of normal time)",
                       "GRTYPE",  35, "Degree/certif-seeking students ( 2-yr institution) Completers within 100% of normal time total",
                       "GRTYPE",  36, "Degree/certif-seeking students ( 2-yr institution) Completers of programs of < 2 yrs (100% of normal time)",
                       "GRTYPE",  37, "Degree/certificate-seeking students ( 2-yr institution) Completers of programs of 2 but < 4 yrs (100% of normal time)",
                       "GRTYPE",  33, "Degree/certif-seeking students ( 2-yr institution) Transfer-out students",
                       "GRTYPE",  47, "Degree/certif-seeking students ( 2-yr institution) noncompleters still enrolled",
                       "GRTYPE",  48, "Degree/certif-seeking students ( 2-yr institution) No longer enrolled"
                       )


gr <- gr %>% left_join(grad_status_codes %>% select(-var), by = c("chrtstat" = "code")) %>%
  select(-chrtstat) %>%
  rename(graduation_rate_status_in_cohort = descrip) %>%
  left_join(cohort_data_codes %>% select(-var), by = c("grtype" = "code")) %>%
  select(-grtype) %>%
  rename(cohort_data = descrip) %>%
  rename(grand_total = grtotlt)


grad <- gr %>%
  filter(graduation_rate_status_in_cohort %in% c(
    "Adjusted cohort (revised cohort minus exclusions)",
    "Completers within 150% of normal time",
    "Completers of programs of less than 2 years (150% of normal time)",
    "Completers of programs of 2 but less than 4 years (150% of normal time)",
    "Completers of bachelor's or equivalent degrees in 6 years",
    "Completers of bachelor's or equivalent degrees (150% of normal time)",
    "Transfer-out students"
  )) %>%
  filter(cohort_data %in% c(
    "4-year institutions, Adjusted cohort (revised cohort minus exclusions)",
    "4-year institutions, Completers within 150% of normal time",
    "4-year institutions, Transfer-out students",
    "Degree/certif-seeking students ( 2-yr institution) Adjusted cohort (revised cohort minus exclusions)",
    "Degree/certif-seeking students ( 2-yr institution) Completers within 150% of normal time total",
    "Degree/certif-seeking students ( 2-yr institution) Transfer-out students"
  ))

spreadtest <- grad %>%
  mutate(graduation_rate = graduation_rate_status_in_cohort) %>%
  mutate(cohort_data = paste(cohort_data, 'grand_total', sep="_")) %>%
  select(unitid, cohort_data, grand_total) %>%
  spread(cohort_data, grand_total) %>%
  clean_names() %>%
  mutate(transfer_students_grand_total = case_when(!is.na(x4_year_institutions_transfer_out_students_grand_total) ~ x4_year_institutions_transfer_out_students_grand_total,  !is.na(degree_certif_seeking_students_2_yr_institution_transfer_out_students_grand_total) ~ degree_certif_seeking_students_2_yr_institution_transfer_out_students_grand_total)) %>%
  mutate(adjusted_cohort_grand_total = case_when(!is.na(x4_year_institutions_adjusted_cohort_revised_cohort_minus_exclusions_grand_total) ~ x4_year_institutions_adjusted_cohort_revised_cohort_minus_exclusions_grand_total,
                                                 !is.na(degree_certif_seeking_students_2_yr_institution_adjusted_cohort_revised_cohort_minus_exclusions_grand_total) ~ degree_certif_seeking_students_2_yr_institution_adjusted_cohort_revised_cohort_minus_exclusions_grand_total)) %>%
  mutate(completes_150perc_grand_total = case_when(!is.na(x4_year_institutions_completers_within_150_percent_of_normal_time_grand_total) ~ x4_year_institutions_completers_within_150_percent_of_normal_time_grand_total,
                                                   !is.na(degree_certif_seeking_students_2_yr_institution_completers_within_150_percent_of_normal_time_total_grand_total) ~ degree_certif_seeking_students_2_yr_institution_completers_within_150_percent_of_normal_time_total_grand_total)) %>%
  select(unitid, adjusted_cohort_grand_total, transfer_students_grand_total, completes_150perc_grand_total)






# crap ------------------------------------------------------------------------------------------------------------



select(Institution_Name, Sector, total_complete_avg, debt_to_earnings_ratio_best, full_time_retention_rate_mean, total_students_entering_2016)