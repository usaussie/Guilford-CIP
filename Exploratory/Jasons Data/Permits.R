require(tidyverse)
require(siverse)
require(httr)

pm <- read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/fourMonthsPermitting.csv") %>%
  bind_rows(read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/fiveYearPermitting.csv"), .id = "source") %>%
  clean_names()

guilfordzips <- c(27263, 27214, 27233, 27235, 27249, 27401, 27403, 27405, 27406, 27407, 27408, 27409, 27410, 27455, 27265, 27282, 27260, 27262, 27283, 27301, 27310, 27313, 27357, 27358, 27377)

pm <- pm %>% filter(zip %in% guilfordzips)
# Make address for geocoding --------------------------------------------------------------------------------------


pm <- pm %>%
  unite(col = street_address, streetdir, streetnumber, streetname, streetsuffix, remove = F, na.rm = T, sep = " ") %>%
  mutate(full_address = glue("{street_address}, {city}, {state} {zip}"))

# Guilford ArcGIS -------------------------------------------------------------------------------------------------

# distinct_full_address <- pm %>% distinct(full_address)
#
# pb <- progress_estimated(nrow(distinct_full_address))
#
# geo_pull <- distinct_full_address %>%
#   mutate(json = map(full_address, function(full_address) {
#
#     try(pb$tick()$print())
#
    # GET(url = "http://gis.guilfordcountync.gov/arcgis/rest/services/Geocode_Services/GCStrts_Parcels_Composite/GeocodeServer/findAddressCandidates",
    #     query = list(f = "json",
    #                  SingleLine = full_address,
    #                  outSR = "4326",
    #                  outFields = "StreetName, Match_addr",
    #                  maxLocations = 1)) %>%
    #   pluck("content") %>%
    #   rawToChar() %>%
    #   jsonlite::fromJSON() %>%
    #   pluck("candidates")
    #
    # }))
#
# arcgis_geocoded <- geo_pull %>%
#   mutate(json = map(json, ~ if(is.null(.x)) {
#     tibble(attributes.StreetName = NA_character_, attributes.Match_addr = NA_character_)
#   }
#     else do.call(data.frame, c(.x, stringsAsFactors = FALSE)))) %>%
#   unnest()
#
# write_rds(arcgis_geocoded, "~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/permit_addresses_geocoded.rds")

arcgis_geocoded <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/permit_addresses_geocoded.rds")

pm <- pm %>%
  left_join(arcgis_geocoded) %>%
  rename(lat = location.y, lon = location.x)


#Center of Guilford County, NC:
guilford <- c(36.086046, -79.796661)

### Get a map
map <- get_map(location = c(lat = 36.086046, lon = -79.796661), zoom = 9,
               maptype = "roadmap", source = "google")

### When you draw a figure, you limit lon and lat.
guilfordmap <- ggmap(map)

pmtomap <- pm %>%
  filter(!is.na(permitfees)) %>%
  mutate(apptype = str_remove(apptype, " Permit| Web Application")) %>%
  mutate(permit_percentile = permitfees/max(permitfees))

ggmap(map, base_layer = ggplot(pmtomap, aes(x = lon, y = lat))) +
  scale_color_viridis(option = "plasma") + guides(fill = F, color = F, alpha = F, size = F) +
  scale_fill_viridis() +
  geom_density_2d() +
  stat_density_2d(aes(fill = ..level.., alpha = .5), geom = "polygon") +
  scale_x_continuous(limits = c(-80.25, -79.25), expand = c(0, 0)) +
  scale_y_continuous(limits = c(35.8, 36.4), expand = c(0, 0))


ggmap(map, base_layer = ggplot(pmtomap, aes(x = lon, y = lat))) +
  scale_color_viridis(option = "inferno") + guides(fill = F, color = F, alpha = F, size = F) +
  scale_fill_viridis() +
  geom_point(aes(size = permit_percentile, color =  permit_percentile, alpha = permit_percentile)) +
  scale_x_continuous(limits = c(-80.25, -79.25), expand = c(0, 0)) +
  scale_y_continuous(limits = c(35.8, 36.4), expand = c(0, 0))

ggmap(map, base_layer = ggplot(pmtomap, aes(x = lon, y = lat))) +
  guides(fill = F, color = F, alpha = F, size = F) +
  scale_fill_viridis() +
  facet_wrap(~apptype) +
  geom_point(aes(size = permit_percentile, color = apptype)) +
  scale_x_continuous(limits = c(-80.25, -79.25), expand = c(0, 0)) +
  scale_y_continuous(limits = c(35.8, 36.4), expand = c(0, 0))
