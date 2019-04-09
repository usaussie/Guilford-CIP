require(tidyverse)
require(siverse)
require(googleway)
options(warnPartialMatchArgs = F)
#Author: Jon Zadra


#This code is messy.  Google places only allows 20 results at a time (a "page") and then only up to 3 total pages (60 results total).  In order to make sure I'm not missing anything, I've generated a grid of locations around Guilford county, and then done a search around a radius of each point, getting as many pages as possible.  The reuslting list is expected to be full of duplicates.

#Only uncomment and run the below code if you make a change - prevent using our API unless necessary.
# #Center of Guilford County, NC:
#   guilford <- c(36.086046, -79.796661)
#
#
# place_types <- c("supermarket",
#                  "grocery_or_supermarket")
#
#
# bottomleft <- c(35.861792, -80.112286)
# topright <-  c(36.239347, -79.583953)
# bottomright <- c(35.910726, -79.580493)
# topleft <- c(36.243619, -80.023036)
#
# lat <- topleft[1] - seq(0, topleft[1] - bottomleft[1], length.out = 5)
# lon <- bottomleft[2] - seq(0,  bottomleft[2] - bottomright[2], length.out = 5)
#
# location_grid <- tibble(lat, lon) %>%
#   expand(lat, lon)
#
# reslst <- lst()
# iter <- 0
#
# for(h in 1:nrow(location_grid)) {
#   location <- location_grid %>% slice(h) %>% as_vector()
#   message(h)
#
#   for(j in seq(place_types)) {
#     last_token <- NULL
#
#     for(i in 1:3) {
#
#       res <- google_places(location = location,
#                                  radius = 20000,
#                                  place_type = place_types[j],
#                                  page_token = last_token)
#
#       results <- res$results
#
#       last_token <- res$next_page_token
#
#       iter <- iter + 1
#
#       reslst[[iter]] <- results %>% select(id, name, place_id, price_level, rating, user_ratings_total, types) %>% as_tibble() %>% add_column(iter = iter, place_type_search = place_types[j], location_grid = paste(location[1], location[2], sep = ", "))
#
#       if(is.null(last_token)) break
#
#       Sys.sleep(time = 3)
#
#
#       }
#   }
# }

# write_rds(reslst, "~/Google Drive/SI/DataScience/data/Guilford County CIP/Food Stores/full lst.rds")
reslst <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/Food Stores/full lst.rds")

all_results <- bind_rows(reslst)

all_results %>% count(place_id,  sort = T) %>% count(n)

all_results %>% select(-types, -iter, -place_type_search) %>% distinct



all_results %>%
  mutate(istype_gas_station = map_lgl(types, ~any("gas_station" %in% .x)))

results <- all_results %>%
  distinct(id, name, place_id, price_level, rating, user_ratings_total)

