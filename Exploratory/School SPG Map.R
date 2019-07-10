require(tidyverse)
require(siverse)
require(googleway)
require(leaflet)
require(leaflet.extras)
options(warnPartialMatchArgs = F)

# set_key("your key here")

# # Load Data -------------------------------------------------------------------------------------------------------
#
# spg <- bind_rows(
#   read_excel(path_expand("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data/spg1314.xlsx"), skip = 3) %>%
#     add_column(year = 1314) %>%
#     clean_names() %>%
#     rename(district_name = lea_name,
#            state_board_region = sbe_region),
#
#   read_excel(path_expand("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data/spg1415.xlsx"), skip = 7) %>%
#     add_column(year = 1415) %>%
#     clean_names() %>%
#     rename(district_name = lea_name,
#            state_board_region = sbe_district),
#
#   read_excel(path_expand("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data/spg1516.xlsx"), skip = 6) %>%
#     add_column(year = 1516) %>%
#     clean_names(),
#
#   read_excel(path_expand("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data/spg1617.xlsx"), skip = 6) %>%
#     add_column(year = 1617) %>%
#     clean_names() %>%
#     rename(state_board_region = sbe_district)
# )
#
# spg <- spg %>%
#   mutate(state_board_region = str_remove(state_board_region, " Region"),
#          state_board_region = str_replace(state_board_region, "-", " ")) %>%
#   mutate(spg_score = as.numeric(spg_score)) %>%
#   mutate(school_name = str_replace(school_name, "Allen Jay Middle, A Preparatory Academy", "Allen Jay Middle Preparatory Academy")) %>%
#   replace_with_na_all(condition = ~.x == "N/A")
#
# spg <- spg %>%
#   filter(district_name == "Guilford County Schools")
#
#
#
# # Geocode ---------------------------------------------------------------------------------------------------------
#
# spg <- spg %>%
#   distinct(school_name) %>%
#   mutate(place = map(school_name,
#                      function(school_name) {
#                        google_geocode(address = paste0(school_name, ", Guilford County, North Carolina")) %>%
#                          geocode_coordinates() %>%
#                          slice(1) #Just keep the first in case there are multiple results.  This is prone to errors because it isn't based on any ranking.
#                        }
#                      )) %>%
#   unnest(place) %>%
#   right_join(spg)
#
# write_rds(spg, "~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data/spg.rds")

spg <- read_rds("~/Google Drive/SI/DataScience/Data/Guilford County CIP/K-12 Data/spg.rds")

# Map -------------------------------------------------------------------------------------------------------------

#spg_map <-
spg %>%
  group_by(school_name) %>%
  filter(year == max(year)) %>%
  ungroup() %>%
  mutate(popup = glue("<B>{school_name}</B><BR><BR>
                      School Performance Grade: {spg_grade} ({spg_score}%)")) %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(lat = ~lat,
             lng = ~lng,
             popup = ~popup,
             clusterOptions = markerClusterOptions()) %>%
  addSearchOSM(options = searchOptions(filterData = "Guilford"))

write_rds(spg_map, "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/leaflet - spg_map.rds")
