require(tidyverse)
require(siverse)
require(googleway)
options(warnPartialMatchArgs = F)
#Author: Jon Zadra

#Center of Guilford County, NC:
guilford <- c(36.086046, -79.796661)


#This code is messy.  Google places only allows 20 results at a time (a "page") and then only up to 3 total pages (60 results total).  In order to make sure I'm not missing anything, I've generated a grid of locations around Guilford county, and then done a search around a radius of each point, getting as many pages as possible.  The reuslting list is expected to be full of duplicates.
#
# place_types <- c("school")
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
#      for(j in seq(place_types)) {
#        last_token <- NULL
#
#        for(i in 1:3) {
#
#          res <- google_places(location = location,
#                                     radius = 20000,
#                                     place_type = place_types[j],
#                                     page_token = last_token)
#
#          results <- res$results
#
#          last_token <- res$next_page_token
#
#          iter <- iter + 1
#
#          reslst[[iter]] <- results %>% select(id, name, place_id, rating, user_ratings_total, types) %>% as_tibble() %>% add_column(iter = iter, place_type_search = place_types[j], location_grid = paste(location[1], location[2], sep = ", ")) %>% bind_cols(lat = results$geometry$location$lat, lon = results$geometry$location$lng)
#
#          if(is.null(last_token)) break
#
#          Sys.sleep(time = 3)
#
#          }
#      }
#    }
#
# write_rds(reslst, "~/Google Drive/SI/DataScience/data/Guilford County CIP/Parks/schools full lst.rds")
reslst <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/Parks/schools full lst.rds")


all_results <- bind_rows(reslst)

all_results %>% count(place_id,  sort = T) %>% count(n)

results <- all_results %>%
  distinct(id, name, place_id, rating, user_ratings_total, lat, lon)

results <- results %>%
  mutate(place_details = map(place_id, ~google_place_details(.x)))

results <- results %>%
  mutate(zip = map_dbl(place_details, ~.x %>% pluck("result") %>% pluck("address_components") %>% filter(types == "postal_code") %>% pull(short_name) %>% as.numeric))

# Zip codes in Guilford county: https://www.bestplaces.net/find/zip.aspx?st=nc&county=37081
guilfordzips <- c(27263, 27214, 27233, 27235, 27249, 27401, 27403, 27405, 27406, 27407, 27408, 27409, 27410, 27455, 27265, 27282, 27260, 27262, 27283, 27301, 27310, 27313, 27357, 27358, 27377)

results <- results %>% filter(zip %in% guilfordzips | is.na(zip))

write_rds(results, "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/schools.rds")


# google_map(data = results, location = guilford) %>%
#   add_markers()



# Classify Schools ------------------------------------------------------------------------------------------------

require(tidytext)

results %>%
  unnest_tokens(word, name) %>%
  count(word, sort = T)

results <- results %>%
  mutate(class = case_when(str_detect(name, fixed("high", ignore_case = T)) ~ "high",
                           str_detect(name, fixed("elementary", ignore_case = T)) ~ "elementary",
                           str_detect(name, fixed("middle", ignore_case = T)) ~ "middle",
                           str_detect(name, fixed("preschool", ignore_case = T)) ~ "prek",
                           str_detect(name, fixed("high", ignore_case = T)) ~ "high")) #This is prone to error because if they have multiple hits, it will overwrite.  Work in progress to test for thsi or use an alternate method that would catch multi hits.


