require(tidyverse)
require(siverse)
require(leaflet)
require(tidycensus)
require(sf)


# Options ---------------------------------------------------------------------------------------------------------

most_recent_acs_year <- 2017


# Data ------------------------------------------------------------------------------------------------------------

schools <- read_rds("~/Github/Guilford-CIP/dashboard/data/schools.rds")
parks <- read_rds("~/Github/Guilford-CIP/dashboard/data/parks.rds")
food_stores <- read_rds("~/Github/Guilford-CIP/dashboard/data/food_stores.rds")

# Define Functions ------------------------------------------------------------------------------------------------



acsvars <- bind_rows(acs1 = load_variables(2017, "acs1", cache = T),
                      acs5 = load_variables(2017, "acs5", cache = T),
                      .id = "dataset") %>%
  add_column(year = 2017) %>% #to do: don't hardcode year
  mutate(level = str_count(label, pattern = "!!")) %>%
  rowwise() %>%
  mutate(levlab = str_split(label, pattern = "!!") %>% unlist() %>% .[level + 1]) %>%
  ungroup() %>%
  mutate(concept = str_to_title(concept)) %>%
  rename(variable = name) %>%
  separate(col = variable, into = c("table", "row"), sep = "_", remove = F) %>%
  group_by(year, dataset, table) %>%
  mutate(label_lead = lead(label)) %>%
  mutate(is_summary = str_detect(label_lead, label) & !is.na(label_lead)) %>%
  ungroup() %>%
  select(-label_lead)


options(tigris_use_cache = TRUE)

si_acs <- function(table,
                    geography = "county",
                    county = NULL,
                    state = NULL,
                    summary_var = "universe total",
                    survey = "acs5",
                    year = 2017,
                    discard_summary_rows = TRUE,
                    geometry = FALSE,
                    keep_geo_vars = FALSE,
                    shift_geo = TRUE) {

  acsvars <- acsvars %>% filter(dataset == survey, year == year)

  #shift_geo settings
  if(geography != "county" | geography != "state") shift_geo <- F #shift_geo is only available for states and counties
  if(!geometry) shift_geo <- F #get_acs() will throw and error if we ask for shift without asking for geo

  if(summary_var == "universe total") summary_var = paste0(table, "_001")
  summary_label = acsvars %>% filter(variable == summary_var) %>% pull(levlab)

  df <- get_acs(geography = geography,
                table = table,
                county = county,
                state = state,
                output = "tidy",
                year = year,
                cache_table = T,
                summary_var = summary_var,
                survey = survey,
                geometry = geometry,
                keep_geo_vars = keep_geo_vars,
                shift_geo = shift_geo) %>%
    clean_names() %>%
    left_join(acsvars) %>%
    select(-summary_moe) %>%
    select(geoid, geo_name = name, level, levlab, estimate, everything()) %>%
    rename(!!summary_label := summary_est)

  if(discard_summary_rows) {
    df <- df %>%
      filter(!is_summary)
    message("Dropping summary rows.  To keep, run this function with `discard_summary_rows = FALSE`")
  }

  return(df)
}


# Pull tables -----------------------------------------------------------------------------------------------------

guilfordzips <- c(27263, 27214, 27233, 27235, 27249, 27401, 27403, 27405, 27406, 27407, 27408, 27409, 27410, 27455, 27265, 27282, 27260, 27262, 27283, 27301, 27310, 27313, 27357, 27358, 27377)

# explore_tables <- tribble(~title, ~table,
#         "Total Population", "B01003",
#         "Median Household Income", "B19013",
#         "White Pop.", "B02008",
#         "Black Pop.", "B02009",
#         "Am. Indian & Alaska Native Pop.", "B02011",
#         "Asian Pop.", "B02010",
#         "Native Hawaiian and Pacific Isl. Pop.", "B02012",
#         "Other Pop.", "B02013")
#
# #explore_years <- 2010:most_recent_acs_year
#
# explore_mapdata <- map(explore_tables$table, function(table) {
#   si_acs(table, geography = "zcta", year = 2017, geometry = T) %>%
#     filter(geoid %in% guilfordzips) %>%
#     st_transform(crs = "+init=epsg:4326")
# })
#
# write_rds(explore_mapdata, "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/explore_mapdata.rds")

explore_mapdata <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/explore_mapdata.rds")



# Map -------------------------------------------------------------------------------------------------------------

emap <- leaflet()

walk(explore_mapdata, function(layer) {

  #Build palette
  palette <- colorNumeric(
      palette = "viridis",
      domain = layer$estimate
  )

  group <- explore_tables %>% filter(table == unique(layer$table)) %>% pull(title)

  popup <- layer %>%
    transmute(popup = glue("<B>Zip Code: {geoid}</B><BR>
                           <B>{concept}</B><BR><BR>
                           {format(estimate, big.mark = ',')}")) %>%
    pull(popup)

  #str_replace_all(str_wrap(concept, width = 20, exdent = 3), '\n', '<BR>')


  emap <<- emap %>%
    #addTiles(options = tileOptions(minZoom = 5), group = group) %>%
    setMaxBounds(-84, 35, -79, 37) %>%
    addPolygons(data = layer,
                group = group,
                stroke = F,
                fillColor = ~palette(estimate),
                fillOpacity = 0.7,
                popup = popup
    ) %>%
    addLegend(pal = palette,
              values = layer$estimate,
              group = group,
              position = "bottomleft",
              title = group
              )



})

emap <- emap %>%
  addTiles(options = tileOptions(minZoom = 5)) %>%
  addLayersControl(baseGroups = explore_tables$title,
                   overlayGroups = c("schools", "parks", "food"),
                   position = "bottomright",
                   options = layersControlOptions(collapsed = F)) %>%
  hideGroup(c("schools", "parks", "food"))

emap <- emap %>%
  addCircleMarkers(data = food_stores,
                   lat = ~lat, lng = ~lon, popup = ~name,
                   stroke = TRUE, fillOpacity = 0.075,
                   group = "food") %>%
  addMarkers(data = schools,
             lat = ~lat, lng = ~lon, popup = ~name,
             clusterOptions = markerClusterOptions(),
             group = "schools") %>%
  addMarkers(data = parks,
             lat = ~lat, lng = ~lon, popup = ~name,
             clusterOptions = markerClusterOptions(),
             group = "parks")

emap
