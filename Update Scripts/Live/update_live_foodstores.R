require(tidyverse)
require(siverse)
require(googleway)
options(warnPartialMatchArgs = F)
#Author: Jon Zadra

#Center of Guilford County, NC:
  guilford <- c(36.086046, -79.796661)

#This code is messy.  Google places only allows 20 results at a time (a "page") and then only up to 3 total pages (60 results total).  In order to make sure I'm not missing anything, I've generated a grid of locations around Guilford county, and then done a search around a radius of each point, getting as many pages as possible.  The reuslting list is expected to be full of duplicates.

# Only uncomment and run the below code if you make a change - prevent using our API unless necessary.



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
#       reslst[[iter]] <- results %>% select(id, name, place_id, price_level, rating, user_ratings_total, types) %>% as_tibble() %>% add_column(iter = iter, place_type_search = place_types[j], location_grid = paste(location[1], location[2], sep = ", ")) %>% bind_cols(lat = results$geometry$location$lat, lon = results$geometry$location$lng)
#
#       if(is.null(last_token)) break
#
#       Sys.sleep(time = 3)
#
#
#       }
#   }
# }

# write_rds(reslst, "~/Google Drive/SI/DataScience/data/Guilford County CIP/Food Stores/food stores full lst.rds")
reslst <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/Food Stores/food stores full lst.rds")

all_results <- bind_rows(reslst)

all_results %>% count(place_id,  sort = T) %>% count(n)

all_results %>% select(-types, -iter, -place_type_search) %>% distinct



all_results <- all_results %>%
  mutate(istype_gas_station = map_lgl(types, ~any("gas_station" %in% .x)))

results <- all_results %>%
  filter(!istype_gas_station) %>%
  distinct(id, name, place_id, price_level, rating, user_ratings_total, lat, lon)


results <- results %>%
  mutate(place_details = map(place_id, ~google_place_details(.x)))

results <- results %>%
  mutate(zip = map_dbl(place_details, ~.x %>% pluck("result") %>% pluck("address_components") %>% filter(types == "postal_code") %>% pull(short_name) %>% as.numeric))

# Zip codes in Guilford county: https://www.bestplaces.net/find/zip.aspx?st=nc&county=37081
guilfordzips <- c(27263, 27214, 27233, 27235, 27249, 27401, 27403, 27405, 27406, 27407, 27408, 27409, 27410, 27455, 27265, 27282, 27260, 27262, 27283, 27301, 27310, 27313, 27357, 27358, 27377)

results <- results %>% filter(zip %in% guilfordzips | is.na(zip))

write_rds(results, "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/food_stores.rds")


google_map(data = results, location = guilford) %>%
  add_markers()


# Kendall's Updates -------------------------------------------------------

#Food stores Updates

original_food_stores <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/food_stores.rds")
view(original_food_stores)

#Data exploration shows that many Family Dollar and Walmart stores are very close to each other - example 3 Family Dollar stores in High Point
filter_food_stores <- original_food_stores %>%
  filter(str_detect(name, "Publix Event Planning at Westchester Square", negate = TRUE) , str_detect(name, "Superior Foods Supermarket", negate = TRUE)
         , str_detect(name, "The Fresh Market - Corporate Office", negate = TRUE))

save(filter_food_stores, file = "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/food_stores_1.rda")
