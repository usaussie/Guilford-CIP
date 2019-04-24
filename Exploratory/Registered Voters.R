require(tidyverse)
require(siverse)
require(fs)

#This is also available from Jason in that folder, but he shared this code as to  how he obtained it.
temp <- file_temp()
download.file("http://dl.ncsbe.gov.s3.amazonaws.com/data/ncvoter41.zip", temp)
temp <- unzip(temp)
vote <- read_tsv(temp, guess_max = Inf)

vote <- read_csv("/Volumes/GoogleDrive/My Drive/SI/DataScience/data/Guilford County CIP/From Jason/Registered Voters/ncvoter41.csv") #temporary for no internet

guilfordzips <- c(27263, 27214, 27233, 27235, 27249, 27401, 27403, 27405, 27406, 27407, 27408, 27409, 27410, 27455, 27265, 27282, 27260, 27262, 27283, 27301, 27310, 27313, 27357, 27358, 27377)

vote <- vote %>% filter(zip_code%in% guilfordzips)
# Make address for geocoding --------------------------------------------------------------------------------------


vote <- vote %>%
  mutate(full_address = glue("{res_street_address}, {res_city_desc}, {state_cd} {zip_code}"))

# Guilford ArcGIS -------------------------------------------------------------------------------------------------

distinct_full_address <- vote %>% distinct(full_address)

pb <- progress_estimated(nrow(distinct_full_address))

geo_pull <- distinct_full_address %>%
  mutate(json = map(full_address, function(full_address) {

    try(pb$tick()$print())

    GET(url = "http://gis.guilfordcountync.gov/arcgis/rest/services/Geocode_Services/GCStrts_Parcels_Composite/GeocodeServer/findAddressCandidates",
        query = list(f = "json",
                     SingleLine = full_address,
                     outSR = "4326",
                     outFields = "StreetName, Match_addr",
                     maxLocations = 1)) %>%
      pluck("content") %>%
      rawToChar() %>%
      jsonlite::fromJSON() %>%
      pluck("candidates")

  }))

arcgis_geocoded <- geo_pull %>%
  mutate(json = map(json, ~ if(is.null(.x)) {
    tibble(attributes.StreetName = NA_character_, attributes.Match_addr = NA_character_)
  }
  else do.call(data.frame, c(.x, stringsAsFactors = FALSE)))) %>%
  unnest()

write_rds(arcgis_geocoded, "~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/voter_addresses_geocoded.rds")