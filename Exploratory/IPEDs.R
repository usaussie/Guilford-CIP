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



