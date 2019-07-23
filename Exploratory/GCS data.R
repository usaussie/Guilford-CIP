require(tidyverse)
require(siverse)
require(googleway)
require(leaflet)
require(leaflet.extras)
options(warnPartialMatchArgs = F)

# Functions -------------------------------------------------------------------------------------------------------

read_excel_twoheaders <- function(path) {
  merged_names <- suppressMessages(read_excel(path, col_names = F)) %>%
    slice(1:2) %>%
    rownames_to_column %>%
    gather(var, value, -rowname) %>%
    spread(rowname, value) %>%
    fill(`1`, .direction = "down") %>%
    mutate(merged_name = paste(`1`, `2`, sep = "_"),
           merged_name = str_remove(merged_name, "_NA$"),
           merged_name = make_clean_names(merged_name)) %>%
    pull(merged_name)

  read_excel(path, col_names = merged_names) %>%
    slice(-1:-2) %>%
    mutate_if(funs(Hmisc::all.is.numeric(., extras = c(".", "NA", NA, NA_character_))), as.numeric)
}


# Load Data -------------------------------------------------------------------------------------------------------

#NOTE: FOR ALL YEAR VALUES WE ARE USING THE END OF SCHOOL YEAR.  2017-2018 School Year = 2018

grd3_read <- read_excel("/Volumes/GoogleDrive/My Drive/SI/DataScience/data/Guilford County CIP/GCS Indicators/GCS Grade 3 EOG Reading Proficiency.xlsx") %>%
  clean_names() %>%
  fill(school, .direction = "down") %>% #deal with merged cells
  filter(school != "Guilford County Schools") %>% #remove county average
  filter(!is.na(year)) %>%
  replace_with_na(replace = list(reading_eog_3 = "NA")) %>%
  mutate(year = as.numeric(year),
         reading_eog_3 = as.numeric(reading_eog_3)) %>%
  rename(value = reading_eog_3) %>%
  add_column(label_metric = "End of Grade 3 Reading Proficiency")

kdib <- read_excel_twoheaders("/Volumes/GoogleDrive/My Drive/SI/DataScience/data/Guilford County CIP/GCS Indicators/GCS Kindergarten DIBELS BOY by School 2017-18 & 2018-19.xlsx") %>%
  rename(school = school_name) %>%
  filter(!is.na(gcs_school_code)) %>% #get rid of the 2nd header row and the county average
  select(-gcs_school_code) %>%
  gather(key = year, value = value, -school) %>%
  replace_with_na(replace = list(value = "*")) %>%
  mutate(year = parse_number(year) + 1,
         value = as.numeric(value)) %>%
  add_column(label_metric = "DIBELS At or Above Benchmark")

hsgrad <- read_excel_twoheaders("/Volumes/GoogleDrive/My Drive/SI/DataScience/data/Guilford County CIP/GCS Indicators/GCS Graduation Rates By School Over Time.xlsx") %>%
  filter(code != "LEA") %>% #remove county average
  select(-contains("rate_change"), -contains("number_students_in_cohort"), -code) %>%
  gather(key = year, value = value, -school) %>%
  mutate(year = parse_number(year)) %>%
  add_column(label_metric = "Graduation Rate")


act <- read_excel("/Volumes/GoogleDrive/My Drive/SI/DataScience/data/Guilford County CIP/GCS Indicators/GCS Grade 11 ACT Performance Over Time.xlsx") %>%
  clean_names() %>%
  rename(year = reporting_year) %>%
  mutate(act_proficiency = parse_number(act_proficiency)) %>% #has values of ">95".  This makes them "95"
  rename(value = act_proficiency) %>%
  add_column(label_metric = "Grade 11 ACT Proficiency")

post_hs_enrolled <- read_excel_twoheaders("/Volumes/GoogleDrive/My Drive/SI/DataScience/data/Guilford County CIP/GCS Indicators/GCS Student Clearinghouse Information By School & District May 2019.xlsx") %>%
  filter(school != "GUILFORD COUNTY SCHOOLS") %>%
  select(school, contains("1st_year_after")) %>% #Decision point to use first year rather than fall after HS
  select(-contains("change_from")) %>%
  gather(key = year, value = value, -school) %>%
  mutate(year = parse_number(year)) %>%
  add_column(label_metric = "College Attendance")

gcs <- lst(post_hs_enrolled, act, hsgrad, kdib, grd3_read) %>%
  bind_rows(.id = "metric") %>%
  mutate(school = str_squish(school)) %>%
  mutate(label_school_year = paste0(year - 1, "-", year)) %>%
  group_by(year, metric) %>%
  mutate(value = case_when(any(value > 1, na.rm = T) & all(value <= 100, na.rm = T) ~ value / 100,
                           TRUE ~ value)) %>% #Convert any using 0-100 to percent scale 0-1
  mutate(mean_metric_year = mean(value, na.rm = T)) %>%
  ungroup()

# # Geocode ---------------------------------------------------------------------------------------------------------

# gcs <- gcs %>%
#   distinct(school) %>%
#   mutate(place = map(school,
#                      function(school) {
#                        google_geocode(address = paste0(school, ", Guilford County, North Carolina")) %>%
#                          geocode_coordinates() %>%
#                          slice(1) #Just keep the first in case there are multiple results.  This is prone to errors because it isn't based on any ranking.
#                        }
#                      )) %>%
#   unnest(place) %>%
#   right_join(gcs)
#
# write_rds(gcs, "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/gcs.rds")

# gcs <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/gcs.rds") %>%
#   select(school, lat, lng) %>% distinct() %>%
#   left_join(gcs)

# Map -------------------------------------------------------------------------------------------------------------
gcs <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/gcs.rds")


gcs %>%
  group_by(school) %>%
  filter(!is.na(value)) %>%
  filter(year == max(year)) %>%
  ungroup() %>%
  mutate(popup = paste0(label_metric, ": ", scales::percent(value), " (", label_school_year, ")")) %>%
  select(school, lat, lng, metric, popup) %>%
  spread(key = metric, value = popup) %>%
  unite(col = popup, kdib, grd3_read, act, hsgrad, post_hs_enrolled, sep = "<BR>", na.rm = T) %>%
  mutate(popup = paste0("<B>", school, "</B><BR><BR>", popup)) %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(lat = ~lat,
             lng = ~lng,
             popup = ~popup,
             label = ~school,
             clusterOptions = markerClusterOptions())


#%>%
#  addSearchOSM(options = searchOptions(filterData = "Guilford"))




# Timeline --------------------------------------------------------------------------------------------------------

#temp
pickschool <- "Eastern High"



gcs %>%
  filter(school == pickschool) %>%
  gather(key = measure, value = value, value, mean_metric_year) %>%
  mutate(alpha = ifelse(measure == "value", 1, .4)) %>%
  ggplot(aes(x = year, y = value, color = label_metric, alpha = I(alpha), group = interaction(metric, measure))) +
    geom_col(position = "dodge")







# From Sreeja for connecting --------------------------------------------------------------------------------------


# click id map?
output$map <- renderLeaflet({
  pal <- colorFactor(c("#c5972c"), map$OZ)

  leaflet(options = leafletOptions(zoomControl = T,
                                   minZoom = 4, maxZoom = 7,
                                   dragging = T)) %>%
    addPolygons(data = reactive_basemap(), stroke = T, fillOpacity = 1, color = "#c5972c", fillColor = "#fff",
                weight = 0.5) %>%
    addPolygons( data = reactive_map(), layerId = ~as.character(geoid), stroke = F, fillOpacity = 1, color = ~pal(OZ),
                 highlight = highlightOptions(fillColor = "#85661D",bringToFront = T))

})

# Infographics ----

tract_fact <- reactive({
  clicked_geoid <- as.numeric(input$map_shape_click$id)
  allfacts %>%
    mutate(geoid = as.numeric(geoid)) %>%
    filter(geoid %in% clicked_geoid)

})

gcs %>%
  group_by(school) %>%
  filter(year == max(year)) %>%
  ungroup() %>%
  mutate(popup = glue("<B>{school}</B><BR><BR>
                      School Performance Grade: {spg_grade} ({spg_score}%)")) %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(lat = ~lat,
             lng = ~lng,
             popup = ~popup,
             clusterOptions = markerClusterOptions()) %>%
  addSearchOSM(options = searchOptions(filterData = "Guilford"))

write_rds(spg_map, "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/leaflet - spg_map.rds")

