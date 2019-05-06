library(siverse)
library(tidyverse)
library(qgraph)
require(corrplot)
require(nFactors)
select <- dplyr::select



ozpath <- path_expand("~/Google Drive/SI/Current Projects/Catalyst Capital/OZdata/")

ozindex <- read_rds(path(ozpath, "indexzscore.rds"))
ozbigone <- read_rds(path(ozpath, "ozidbigone.rds")) 
ozbigone <- ozbigone %>% select(-socioeconomic_change_flag_1_yes_blank_no, -investment_score_1_low_10_high, -ozzone, -medianrent:-hispanic_percent,-geoid, -tract_type, -state, -county) %>% distinct()
gates <- read_csv("~/Google Drive/SI/Current Projects/Gates/deliverables/Final Deliverables/big_one.csv") %>% mutate(fips_county = as.character(geoid)) %>% mutate(fips_county = str_pad(fips_county, 5, pad = "0")) %>% select(-geoid)
institutions <- read_csv("~/Google Drive/SI/DataScience/data/gates/IPEDS/Full Gates Download/IPEDS Data/Institutions.csv") %>% filter(Year == 2016) 
institutions <- institutions %>% select(`Institution ID`, Latitude, Longitude) %>% clean_names() %>% mutate(unitid = institution_id)


bigone <- gates %>% 
  left_join(ozbigone) %>% 
  left_join(institutions)


guilford <- bigone %>% 
  filter(fips_county=="37081") %>% 
  select(Institution_Name, Sector, total_complete_avg, debt_to_earnings_ratio_best, full_time_retention_rate_mean, total_students_entering_2016) %>% 
  slice(-9:-10)

save(guilford, file = "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/ipeds.rda")



plot <- guilford %>% 
  select(Institution_Name, total_complete_avg)


billboarder() %>%
  bb_barchart(data = plot, x = "total_complete_avg", y = "Institution_Name", rotated = TRUE) %>% 
  #bb_axis(x = list(tick = list(fit = T)), y = list(tick = list(fit = T))) %>%
  bb_add_style(text = "font-size: 75%", position = "center"
  ) %>% 
  bb_legend(show = FALSE) 
