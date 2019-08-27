require(tidyverse)
require(googleway)
options(warnPartialMatchArgs = F)


# Options ---------------------------------------------------------------------------------------------------------

# You will need to set the google api key using the following code in the console.   DO NOT SAVE THE KEY in this file, as it will be visible to anyone on github!  Contact Tara if you do not have the key.

set_key("your key here") #Run in console only!

# Be sure that you have enabled the "Places API" in your developer console.



# Data Pull -------------------------------------------------------------------------------------------------------

#Google places only allows 20 results at a time (a "page") and then only up to 3 total pages (60 results total).  In order to make sure I'm not missing anything, I've generated a grid of locations around Guilford county, and then done a search around a radius of each point, getting as many pages as possible.  The reuslting list is expected to be full of duplicates.

guilford <- c(36.086046, -79.796661)

place_types <- c("park")


bottomleft <- c(35.861792, -80.112286)
topright <-  c(36.239347, -79.583953)
bottomright <- c(35.910726, -79.580493)
topleft <- c(36.243619, -80.023036)

lat <- topleft[1] - seq(0, topleft[1] - bottomleft[1], length.out = 5)
lon <- bottomleft[2] - seq(0,  bottomleft[2] - bottomright[2], length.out = 5)

location_grid <- tibble(lat, lon) %>%
  expand(lat, lon)

reslst <- lst()
iter <- 0

for(h in 1:nrow(location_grid)) {
  location <- location_grid %>% slice(h) %>% as_vector()
  message(h)

  for(j in seq(place_types)) {
    last_token <- NULL

    for(i in 1:3) {

      res <- google_places(location = location,
                           radius = 20000,
                           place_type = place_types[j],
                           page_token = last_token)

      results <- res$results

      last_token <- res$next_page_token

      iter <- iter + 1

      reslst[[iter]] <- results %>% select(id, name, place_id, rating, user_ratings_total, types) %>% as_tibble() %>% add_column(iter = iter, place_type_search = place_types[j], location_grid = paste(location[1], location[2], sep = ", ")) %>% bind_cols(lat = results$geometry$location$lat, lon = results$geometry$location$lng)

      if(is.null(last_token)) break

      Sys.sleep(time = 3)

    }
  }
}


all_results <- bind_rows(reslst)

results <- all_results %>%
  distinct(id, name, place_id, rating, user_ratings_total, lat, lon)

results <- results %>% #Pull additional data to get zip code and other stuff
  mutate(place_details = map(place_id, ~google_place_details(.x)))

results <- results %>% #unnest the zip and name
  mutate(zip = map_dbl(place_details, ~.x %>% pluck("result") %>% pluck("address_components") %>% filter(types == "postal_code") %>% pull(short_name) %>% as.numeric))

# Zip codes in Guilford county: https://www.bestplaces.net/find/zip.aspx?st=nc&county=37081
guilfordzips <- c(27263, 27214, 27233, 27235, 27249, 27401, 27403, 27405, 27406, 27407, 27408, 27409, 27410, 27455, 27265, 27282, 27260, 27262, 27283, 27301, 27310, 27313, 27357, 27358, 27377)

results <- results %>% filter(zip %in% guilfordzips | is.na(zip)) #keep only those that are in Guilford

write_rds(results, "~/Google Drive/SI/DataScience/data/Guilford County CIP/Parks/parks_temp.rds")

# Manually filter incorrect results -------------------------------------------------------------------------------

results %>% arrange(name) %>% View()

results %>%
  filter(name != "Archdale Park and Recreation Maintenance Dept.") %>%
  filter(name != "B and B Lenten Roses") %>%
  filter(name != "Bur-Mil Clubhouse") %>%
  filter(name != "Bur-Mil Park Pier") %>%
  filter(name != "Camp Gray Rock") %>%
  filter(name != "Carolina Marina") %>%
  filter(name != "Carolina Air Canine LLC") %>%
  filter(name != "Greensboro KOA Journey") %>% ### SREEJA HAVE STUDENT CONTINUE THIS CULLING
  

#parks <- results

# save(results, file ="~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/parks.rda")
  
