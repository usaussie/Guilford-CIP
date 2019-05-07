require(tidyverse)
require(siverse)
require(ggridges)
require(googleway)
require(httr)

options(warnPartialMatchArgs = F)


# Dictionary ------------------------------------------------------------------------------------------------------

dicdr <- read_excel("G:/My Drive/SI/DataScience/data/Guilford County CIP/From Jason/2014 DEATH DETAIL DESCRIPTION_NS.XLS") %>%
  clean_names()
# dicdr <- read_excel("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/2014 DEATH DETAIL DESCRIPTION_NS.XLS") %>%
#   clean_names()

dicdr <- dicdr %>% fill(everything())

dicdr <- dicdr %>%
  mutate(name = make_clean_names(name))

dicdr <- dicdr %>%
  mutate(variable = str_remove(variable, "Decedent's Race--"))


# Data ------------------------------------------------------------------------------------------------------------

# dr <- read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_records_test.csv", guess_max = 553841) %>%
#   clean_names() %>%
#   remove_empty(which = "cols")

dr <- read_csv("G:/My Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_records_test.csv", guess_max = 553841) %>%
  clean_names() %>%
  remove_empty(which = "cols")

dr <- dr %>%
  mutate(age = as.integer(age),
         dob = paste(dob_yr, dob_mo, dob_dy, sep = "-"),
         dob = ymd(dob))

# Zip codes in Guilford county: https://www.bestplaces.net/find/zip.aspx?st=nc&county=37081
guilfordzips <- c(27263, 27214, 27233, 27235, 27249, 27401, 27403, 27405, 27406, 27407, 27408, 27409, 27410, 27455, 27265, 27282, 27260, 27262, 27283, 27301, 27310, 27313, 27357, 27358, 27377)

dr <- dr %>% filter(zipcode %in% guilfordzips)



# Geocode Addresses -----------------------------------------------------------------------------------------------


dr <- dr %>%
  mutate(addrpred = ifelse(addrpred %in% c("N", "S", "E", "W", "NE", "NW", "SE", "SW"), yes = addrpred, no = NA),
         addrpost = ifelse(addrpost %in% c("N", "S", "E", "W", "NE", "NW", "SE", "SW"), yes = addrpost, no = NA)) %>%
  unite(col = street_address, addrnum, addrpred, addrname, addrsuff, addrpost, sep = " ", na.rm = T, remove = F) %>%
  add_column(state = "NC") %>%
  mutate(full_address = paste0(street_address, ", ", cityrestext, ", ", state, " ", zipcode))

dr %>%
  select(street_address, cityrestext, state, zipcode) %>%
  write_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/addresses for texas am.csv")

# Guilford ArcGIS -------------------------------------------------------------------------------------------------

# distinct_full_address <- dr %>% distinct(full_address)
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
#     }))
#
# arcgis_geocoded <- geo_pull %>%
#   mutate(json = map(json, ~ if(is.null(.x)) {
#     tibble(attributes.StreetName = NA_character_, attributes.Match_addr = NA_character_)
#   }
#     else do.call(data.frame, c(.x, stringsAsFactors = FALSE)))) %>%
#   unnest()
#
# write_rds(arcgis_geocoded, "~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_addresses_geocoded.rds")

arcgis_geocoded <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_addresses_geocoded.rds")

# not_geocoded <- geocoded %>% filter(is.na(location.x)) %>% select(full_address)
#
#
# not_geocoded %>%
#   left_join(dr %>% select(full_address, street_address, cityrestext, state, zipcode)) %>%
#   distinct() %>%
#   write_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/addresses for texas am.csv")

texas_geocoded <- read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/texas geocoded results.csv")

all_geocoded <- bind_rows(arcgis_geocoded %>%
            filter(!is.na(location.x)) %>%
            select(full_address, lat = location.y, lon = location.x),
          texas_geocoded %>%
            select(full_address, lat = Latitude, lon = Longitude) %>%
            filter(!is.na(lat))
  )

dr <- dr %>%
  left_join(all_geocoded)


# Supplement with google maps geocoding NOT CURRENTLY NEEDED---------------------------------------------------------------------------

# THIS IS NOT NEEDED
# google_maps_batch_geocode <- function(full_address) {
#
#   pb$tick()$print()
#
#   res <- google_geocode(full_address)
#
#   broke <<- res
#
#   #cat(blue(full_address, ": "), yellow(res$status), "\n", sep = "")
#
#   if(res$status == "OK") {
#
#     geo <- geocode_coordinates(res) %>% as_tibble()
#
#     formatted_address <- geocode_address(res)
#
#     geocode <- bind_cols(geo, formatted_address = formatted_address)
#   }
#   else geocode <- tibble(lat = NA, lng = NA, formatted_address = NA)
#
#   ext_geo <<- bind_rows(ext_geo, bind_cols(full_address, geocode))
#
#   return(geocode)
# }
#
# #ext_geo <- tibble()
#
# gmbc_limited <- limit_rate(google_maps_batch_geocode, rate(40, 1))
#
# pb <- progress_estimated(nrow(not_geocoded))
# gmbc_results <- not_geocoded %>%
#   mutate(geocode_result = map(.x = full_address, gmbc_limited)) %>%
#   unnest()

#write_rds(geocoded_dr, "~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/geocoded_dr.rds")


# Race ------------------------------------------------------------------------------------------------------------


#Race
dicdr %>% filter(str_detect(name, "race")) %>%
  select(variable, name) %>%
  spread(name, variable)


dr <- dr %>%
  mutate(race1 = ifelse(race1 == "Y", "White", NA),
         race2 = ifelse(race2 == "Y", "Black", NA),
         race3 = ifelse(race3 == "Y", "AIAN", NA),
         race4 = ifelse(race4 == "Y", "Asian Indian", NA),
         race5 = ifelse(race5 == "Y", "Chinese", NA),
         race6 = ifelse(race6 == "Y", "Filipino", NA),
         race7 = ifelse(race7 == "Y", "Japanese", NA),
         race8 = ifelse(race8 == "Y", "Korean", NA),
         race9 = ifelse(race9 == "Y", "Vietnamese", NA),
         race10 = ifelse(race10 == "Y", "Other Asian", NA),
         race11 = ifelse(race11 == "Y", "Native Hawaiian", NA),
         race12 = ifelse(race12 == "Y", "Guamanian or Chamorro", NA),
         race13 = ifelse(race13 == "Y", "Samoan", NA),
         race14 = ifelse(race14 == "Y", "Other Pacific Islander", NA),
         race15 = ifelse(race15 == "Y", "Other", NA),
         )

#Manner
dr <- dr %>%
  mutate(manner = case_when(manner == "N" ~ "Natural",
                            manner == "A" ~ "Accident",
                            manner == "S" ~ "Suicide",
                            manner == "H" ~ "Homicide",
                            manner == "P" ~ "Pending",
                            manner == "C" ~ "Can't Determine",
                            is.na(manner) ~ "Unknown"))

dr %>%
  select(-(race16:race23)) %>%
  unite(col = "race", starts_with("race"), na.rm = T) %>%
  count(race)

dr <- dr %>%
  mutate(whiteblack = case_when(race2 == "Black" ~ "Black",
                                race1 == "White" ~ "White",
                                is.na(race1) & is.na(race2) ~ "Other"))

dr %>%
  filter(age <= 135, sex != "U", whiteblack != "Other") %>%
  ggplot(aes(x = age, y = whiteblack, fill = whiteblack)) + geom_density_ridges() +
  scale_fill_manual(values = c("black", "white")) + theme_ridges() + guides(fill = F)

dr %>%
  filter(age <= 135, sex != "U", whiteblack != "Other") %>%
  ggplot(aes(x = dod_yr, y = age, color = whiteblack)) + geom_point() + geom_smooth()


dr %>%
  filter(age <= 135, sex != "U", whiteblack != "Other") %>%
  unite(sexrace, whiteblack, sex) %>%
  tabyl(manner, sexrace) %>%
  adorn_percentages("col") %>%
  untabyl() %>%
  filter(manner != "Natural") %>%
  gather(sexrace, pct, -manner) %>%
  separate(sexrace, into = c("Race", "Sex")) %>%
  ggplot(aes(x = manner, y = pct, fill = Race, color = Sex)) + geom_col(position = "dodge", size = 2) + scale_y_continuous(labels = scales::percent) + scale_fill_manual(values = c("black","white")) + scale_color_manual(values = c("pink", "lightblue"))


  ggplot(aes(x = manner, fill = whiteblack)) + geom_bar() + facet_wrap(~sex)


dr %>%
  filter(age <= 135, sex != "U", whiteblack != "Other") %>%
  unite(sexrace, whiteblack, sex) %>%
  tabyl(manner, veteran, sexrace) %>%
  adorn_percentages("col") %>%
  adorn_pct_formatting()

dr %>%
  filter(age <= 135, sex != "U", whiteblack != "Other") %>%
  filter(manner == "Suicide") %>%
  tabyl(veteran, whiteblack, sex) %>%
  adorn_percentages("col") %>%
  adorn_pct_formatting()


# Map -------------------------------------------------------------------------------------------------------------

dr %>%
  filter(lat > 35.5, lon < -79.5, age > 60, age < 90) %>% #limit our viewport and color scale.
  ggplot(aes(x = lon, y = lat, color = age)) +
  geom_point(size = .4) +
  scale_color_viridis(option = "plasma", direction = -1)



# Billboarder for dashboard -----------------------------------------------

pct <- function(x) (x*100)

deaths <- dr %>%
  filter(age <= 135, sex != "U", whiteblack != "Other") %>% 
  unite(sexrace, whiteblack, sex) %>%
  tabyl(manner, sexrace) %>%
  adorn_percentages("col") %>%
  untabyl() %>% 
  mutate_if(is.numeric, pct )

save(deaths, file = "G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/deaths.rda")


library(billboarder)


deaths_un <- deaths %>% filter(manner== "Accident"|manner == "Homicide"| manner == "Suicide"| manner == "Unknown")

billboarder() %>% 
  bb_barchart(data = deaths_un)
