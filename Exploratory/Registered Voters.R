require(tidyverse)
require(siverse)
require(fs)
library(billboarder)


#This is also available from Jason in that folder, but he shared this code as to  how he obtained it.
# temp <- file_temp()
# download.file("http://dl.ncsbe.gov.s3.amazonaws.com/data/ncvoter41.zip", temp)
# temp <- unzip(temp)
# vote <- read_tsv(temp, guess_max = Inf)

#vote <- read_csv("/Volumes/GoogleDrive/My Drive/SI/DataScience/data/Guilford County CIP/From Jason/Registered Voters/ncvoter41.csv") #temporary for no internet

# guilfordzips <- c(27263, 27214, 27233, 27235, 27249, 27401, 27403, 27405, 27406, 27407, 27408, 27409, 27410, 27455, 27265, 27282, 27260, 27262, 27283, 27301, 27310, 27313, 27357, 27358, 27377)
# 
# vote <- vote %>% filter(zip_code%in% guilfordzips)
# # Make address for geocoding --------------------------------------------------------------------------------------
# 
# 
# vote <- vote %>%
#   mutate(full_address = glue("{res_street_address}, {res_city_desc}, {state_cd} {zip_code}"))
# 
# # Guilford ArcGIS -------------------------------------------------------------------------------------------------
# 
# distinct_full_address <- vote %>% distinct(full_address)
# 
# pb <- progress_estimated(nrow(distinct_full_address))
# 
# geo_pull <- distinct_full_address %>%
#   mutate(json = map(full_address, function(full_address) {
# 
#     try(pb$tick()$print())
# 
#     GET(url = "http://gis.guilfordcountync.gov/arcgis/rest/services/Geocode_Services/GCStrts_Parcels_Composite/GeocodeServer/findAddressCandidates",
#         query = list(f = "json",
#                      SingleLine = full_address,
#                      outSR = "4326",
#                      outFields = "StreetName, Match_addr",
#                      maxLocations = 1)) %>%
#       pluck("content") %>%
#       rawToChar() %>%
#       jsonlite::fromJSON() %>%
#       pluck("candidates")
# 
#   }))
# 
# arcgis_geocoded <- geo_pull %>%
#   mutate(json = map(json, ~ if(is.null(.x)) {
#     tibble(attributes.StreetName = NA_character_, attributes.Match_addr = NA_character_)
#   }
#   else do.call(data.frame, c(.x, stringsAsFactors = FALSE)))) %>%
#   unnest()
# 
# write_rds(arcgis_geocoded, "~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/voter_addresses_geocoded.rds")



# Voters ------------------------------------------------------------------

vote <- read_csv("G:/My Drive/SI/DataScience/data/Guilford County CIP/From Jason/Registered Voters/ncvoter41.csv") #temporary for no internet


levels(as.factor(vote$party_cd))
levels(as.factor(vote$race_code))

# Race codes: "A" "B" "I" "M" "O" "U" "W"
# Guessing? :

# A: Asian
# B: Black
# I: American Indian
# M: Multiracial
# O: Other
# U: Unknown
# W: White

active_voters <- vote %>% 
  filter(voter_status_desc == "ACTIVE") %>% 
  select(county_id, county_desc, voter_status_desc, race_code, ethnic_code, party_cd, gender_code, birth_year)


active_voters <- active_voters %>% 
  mutate(party_cd = case_when(party_cd == "CST"~"Constitution Party",
                              party_cd == "DEM"~ "Democratic Party",
                              party_cd == "GRE"~"Green Party",
                              party_cd == "LIB" ~ "Libertarian Party", 
                              party_cd == "REP"~ "Republican Party",
                              party_cd == "UNA" ~ "Unaffiliated")) %>% 
  mutate(race_code = case_when(race_code == "A" ~ "Asian",
                               race_code == "B" ~ "Black", 
                               race_code == "I"~"Native American",
                               race_code == "M" ~ "Multiracial", 
                               race_code == "O" ~"Other", 
                               race_code == "U" ~"Unknown", 
                               race_code == "W" ~"White")) %>% 
  mutate(gender_code = case_when(gender_code == "M" ~ "Male", 
                                 gender_code == "F" ~ "Female", 
                                 gender_code == "U" ~ "Unknown"))


#save (active_voters, file = "G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/voters.rda")

# Party affiliation
party <- active_voters %>% 
  count(party_cd) 

billboarder(data = party) %>% 
  bb_donutchart()


# Ethnicity

voters_ethn <- active_voters %>% 
  count(ethnic_code) 
 
billboarder(data = voters_ethn) %>% 
  bb_donutchart()

# Race

voters_race <- active_voters %>% 
  count(race_code)

billboarder(data = voters_race) %>% 
  bb_donutchart()



# Gender

voters_gender <- active_voters %>% 
  count(gender_code) %>% 
  filter(!is.na(gender_code))

billboarder(data = voters_gender) %>% 
  bb_donutchart()


# Race and Party


voters_rp <- active_voters %>% 
  group_by(party_cd, race_code) %>% 
  summarise(count = n()) %>% 
  mutate(denom = sum(count)) %>% 
  mutate(perc = round(count/denom*100, 0) ) %>% 
  select(party_cd, race_code, perc) %>% 
  filter(perc!=0) %>%
  filter(!is.na(perc)) %>% 
  spread(race_code, perc) 


billboarder() %>% 
  bb_barchart(data = voters_rp)
  

# gender and Party

voters_gp <- active_voters %>% 
  group_by(gender_code, party_cd) %>% 
  summarise(count = n()) %>% 
  mutate(denom = sum(count)) %>% 
  mutate(perc = round(count/denom*100, 0) ) %>% 
  select(gender_code, party_cd, perc) %>% 
  filter(perc!=0) %>%
  filter(!is.na(perc), !is.na(gender_code)) %>% 
  spread(party_cd, perc)

billboarder() %>% 
  bb_barchart(data = voters_gp)



# Age for active voters?

allvoters_age <- vote %>% 
  mutate(current_age  = 2019 - birth_year) %>% 
mutate(age_bin = case_when(current_age<25 ~ "less than 25", 
                           current_age<60 ~ "25- 60", 
                           current_age >=60 ~"above 60")) %>% 
  select(age_bin, voter_status_desc) %>% 
  group_by(age_bin, voter_status_desc) %>% 
  summarise(count = n()) %>% 
  mutate(denom = sum(count)) %>% 
  mutate(perc = round(count/denom*100, 0)) %>% 
  filter(perc!=0) %>% 
  select(age_bin, voter_status_desc, perc) %>% 
  spread(voter_status_desc, perc)

billboarder(data = allvoters_age) %>% 
  bb_barchart()


# Age and Party


voters_ap <- vote %>% 
  mutate(current_age  = 2019 - birth_year) %>% 
  mutate(age_bin = case_when(current_age<25 ~ "less than 25", 
                             current_age<60 ~ "25- 60", 
                             current_age >=60 ~"above 60")) %>% 
  select(age_bin, party_cd) %>% 
  group_by(age_bin, party_cd) %>% 
  summarise(count = n()) %>% 
  mutate(denom = sum(count)) %>% 
  mutate(perc = round(count/denom*100, 0)) %>% 
  filter(perc!=0) %>% 
  select(age_bin, party_cd, perc) %>% 
  spread(party_cd, perc)

billboarder() %>% 
  bb_barchart(data = voters_ap
              )



#Voter status and race

voter_status <- vote %>% 
  group_by(race_code, voter_status_desc) %>% 
  summarise(count = n()) %>% 
  mutate(denom = sum(count)) %>% 
  mutate(perc = round(count/denom*100,0)) %>% 
  select(race_code, voter_status_desc, perc) %>% 
  spread(voter_status_desc,perc )

billboarder(data = voter_status) %>% 
  bb_barchart()
  

