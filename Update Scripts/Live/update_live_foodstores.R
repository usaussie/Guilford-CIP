require(tidyverse)
require(googleway)
options(warnPartialMatchArgs = F)


# Options ---------------------------------------------------------------------------------------------------------

# You will need to set the google api key using the following code in the console.   DO NOT SAVE THE KEY in this file, as it will be visible to anyone on github!  Contact Tara if you do not have the key.

set_key("your key here") #Run in console only!

# Be sure that you have enabled the "Places API" in your developer console.



# Data Pull -------------------------------------------------------------------------------------------------------


#Google places only allows 20 results at a time (a "page") and then only up to 3 total pages (60 results total).  In order to make sure I'm not missing anything, I've generated a grid of locations around Guilford county, and then done a search around a radius of each point, getting as many pages as possible.  The reuslting list is expected to be full of duplicates.


guilford <- c(36.086046, -79.796661) #Center of Guilford County, NC:

place_types <- c("supermarket",
                 "grocery_or_supermarket")

#Define the bounds
bottomleft <- c(35.861792, -80.112286)
topright <-  c(36.239347, -79.583953)
bottomright <- c(35.910726, -79.580493)
topleft <- c(36.243619, -80.023036)

#split them up
lat <- topleft[1] - seq(0, topleft[1] - bottomleft[1], length.out = 5)
lon <- bottomleft[2] - seq(0,  bottomleft[2] - bottomright[2], length.out = 5)

location_grid <- tibble(lat, lon) %>%
  expand(lat, lon)

reslst <- lst()
iter <- 0

for(h in 1:nrow(location_grid)) { #for each location
  location <- location_grid %>% slice(h) %>% as_vector()
  message(h)

  for(j in seq(place_types)) { #for each place type
    last_token <- NULL

    for(i in 1:3) { #each page of results

      res <- google_places(location = location,
                                 radius = 20000,
                                 place_type = place_types[j],
                                 page_token = last_token)

      results <- res$results

      last_token <- res$next_page_token

      iter <- iter + 1

      reslst[[iter]] <- results %>% select(id, name, place_id, price_level, rating, user_ratings_total, types) %>% as_tibble() %>% add_column(iter = iter, place_type_search = place_types[j], location_grid = paste(location[1], location[2], sep = ", ")) %>% bind_cols(lat = results$geometry$location$lat, lon = results$geometry$location$lng)

      if(is.null(last_token)) break #if there is no next page because there were only 1 or 2 results pages

      Sys.sleep(time = 3)


      }
  }
}

all_results <- bind_rows(reslst)


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


# Manual removal of stores ----------------------------------------------------------------------------------------

#Take a look at the results and see if any don't seem like what we're after - you may want to use google maps to look at photos and place descriptions.

results %>% count(name, sort = T)

results <- results %>%
  filter(name != "Publix Event Planning at Westchester Square") %>%
  filter(name != "The Fresh Market - Corporate Office") %>%
  filter(name != "Cà Phê Hâi Âu") %>%
  filter(name != "Iniciativa Duarte") %>%
  filter(name != "Home Storage Center and Bishops' Storehouse") %>%
  filter(name != "La Guadalupana") %>%
  filter(name != "Little Mexico")


# save(filter_food_stores, file = "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/food_stores_1.rda")
#
# write_rds(results, "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/food_stores.rds")