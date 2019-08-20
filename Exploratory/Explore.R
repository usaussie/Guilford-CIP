require(tidyverse)
require(siverse)
require(leaflet)
require(tidycensus)
require(sf)
require(crayon)
require(furrr)


# Options ---------------------------------------------------------------------------------------------------------

most_recent_acs_year <- 2017

census_api_key("your key here")


# Data ------------------------------------------------------------------------------------------------------------

schools <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/gcs.rds") %>%
  distinct(school, lat, lng)
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
                    shift_geo = TRUE,
                    key = NULL) {

  acsvars <- acsvars %>% filter(dataset == survey, year == year)

  #shift_geo settings
  if(geography != "county" | geography != "state") shift_geo <- F #shift_geo is only available for states and counties
  if(!geometry) shift_geo <- F #get_acs() will throw and error if we ask for shift without asking for geo

  #Set up the summary var
  if(acsvars %>% filter(table == !!table) %>% nrow() > 1) { #Some tables only have 1 row, and therefore no summary row

    if(summary_var == "universe total") summary_var = paste0(table, "_001")
    summary_label = acsvars %>% filter(variable == summary_var) %>% pull(levlab)
  } else summary_var <- NULL

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
                shift_geo = shift_geo,
                key = key) %>%
    clean_names() %>%
    left_join(acsvars) %>%
    select(-matches("summary_moe")) %>% #may not have this for a 1 row table, matches avoids an error
    select(geoid, geo_name = name, level, levlab, estimate, everything()) %>%
    try(rename(!!summary_label := summary_est)) #may not have this for a 1 row table

  if(discard_summary_rows) {
    df <- df %>%
      filter(!is_summary)
    message("Dropping summary rows.  To keep, run this function with `discard_summary_rows = FALSE`")
  }

  return(df)
}


# Pull tables -----------------------------------------------------------------------------------------------------

### WARNING WARNING WARNING: DIFFERENT YEARS MAY NOT MATCH VARIABLE NAMES!!!

explore_tables <- tribble(~short_title, ~table, ~geography, ~value_type,
         "Total Population", "B01003", "block group", "estimate",
         "Median Household Income", "B19013", "block group", "estimate",
         "White Population", "B02008", "block group", "estimate",
         "Black Population", "B02009", "block group", "estimate",
         "Am. Indian & Alaska Native Pop.", "B02011", "block group", "estimate",
         "Asian Population", "B02010", "block group", "estimate",
         "Native Hawaiian and Pacific Isl. Population", "B02012", "block group", "estimate",
         "Other Population", "B02013", "block group", "estimate",
         "Receipt of Food Stamps / SNAP", "B22003_002", "tract", "percent")

explore_years <- 2013:(most_recent_acs_year - 1)


plan(multisession)
#plan(list(tweak(remote, workers = "u0982704@daniels-imac-pro.local"), multiprocess)) #This does remote and multiprocess on the remote


#temp_census_api_key <- "your key here" #only needed for remote future evaluation
temp_census_api_key <-  NULL #need this if no key provided, but depends on key being installed and set locally using census_api_key().

temp_census_api_key <- "b96f50cb268bcd73ad8131793abfc542d5908221" #Delete before distributing

explore_acsdata <- explore_tables %>%
  group_split(table) %>%
  future_map(function(table) {

    var_only <- str_detect(table$table, ".*_\\d{3}") #if we specified a variable in the table column

    as_percent <- table$value_type == "percent"

    if(var_only) { #split the variable into table and row
     table <- table %>% separate(table, into = c("table", "row"), sep = "_")
    }


    #First get the most recent year with the geometry attached
    geo_table <- si_acs(table$table, geography = table$geography, year = most_recent_acs_year, county = "Guilford County", state = "NC", geometry = T, key = temp_census_api_key, discard_summary_rows = !var_only) %>%
      st_transform(crs = "+init=epsg:4326") %>%
      add_column(short_title = table$short_title)

    if(as_percent) {
      geo_table <- geo_table %>% mutate(estimate = estimate / summary_est)
      }

    geo_table <- geo_table %>%
      rename(!!paste0("est", most_recent_acs_year) := estimate) %>%
      select(-moe, -year, -matches("Total"), -matches("summary_est")) #some tables may not have these, so this "matches" avoids an error



    #Now get the rest without geometry and attach to the table with geometry
    data_tables <- map(explore_years, function(explore_years) {
      new_table <- si_acs(table$table, geography = table$geography, year = explore_years, county = "Guilford County", state = "NC", geometry = F, key = temp_census_api_key, discard_summary_rows = !var_only)

      if(as_percent) {
        new_table <- new_table %>% mutate(estimate = estimate / summary_est)
      }

      new_table <- new_table %>%
        rename(!!paste0("est", explore_years) := estimate) %>%
        select(-moe, -year, -matches("Total"), -matches("summary_est")) #some tables may not these, so this "matches" avoids an error
    }) %>%
      reduce(left_join)

    if(var_only) { #Cull it if we were passed a specific variable
      geo_table <- geo_table %>% filter(row == !!table$row)
      data_tables <- data_tables %>% filter(row == !!table$row)
    }

    combined_table <- left_join(geo_table, data_tables) %>%
      add_column(as_percent)



    return(combined_table)
  })

write_rds(explore_acsdata, "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/explore_acsdata.rds")

explore_acsdata <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/explore_acsdata.rds")



# Map -------------------------------------------------------------------------------------------------------------

exploremap <- leaflet()

shiny_selected_year1 <- 2013
shiny_selected_year2 <- 2017


map(explore_acsdata, function(layer) {

  estcolumn <- paste0("est", shiny_selected_year1)

  as_percent <- layer %>% slice(1) %>% pull(as_percent) #Do we need to format as percent?
  if(as_percent) {
    exp_labformat <- labelFormat(transform = function(x) 100*x, suffix = "%")
  } else exp_labformat <- labelFormat()

  layer <- layer %>%
    rename(estimate = estcolumn) %>%
    filter(!is.na(estimate))

  #Build palette
  palette <- colorNumeric(
      palette = "viridis",
      domain = layer$estimate
  )

  group <- layer %>% slice(1) %>% pull(short_title)

  popup <- layer %>%
    transmute(popup = glue("<B>{concept}</B><BR><BR>
                           {format(estimate, big.mark = ',')}")) %>%
    pull(popup)

  #str_replace_all(str_wrap(concept, width = 20, exdent = 3), '\n', '<BR>')


  exploremap <<- exploremap %>%
    #addTiles(options = tileOptions(minZoom = 5), group = group) %>%
    setMaxBounds(-84, 35, -79, 37) %>%
    addPolygons(data = layer,
                group = group,
                stroke = F,
                fillColor = ~palette(estimate),
                fillOpacity = 0.7,
                popup = popup
    )

  explore_legend <- tibble(palette = lst(palette),
                           minval = min(layer$estimate),
                           maxval = max(layer$estimate),
                           exp_labformat = lst(exp_labformat),
                           group,
                           as_percent)

  return(explore_legend)

}) %>% bind_rows -> explore_legend

exploremap <- exploremap %>%
  addTiles(options = tileOptions(minZoom = 5)) %>%
  addLayersControl(baseGroups = explore_acsdata %>% map_chr(~.x %>% slice(1) %>% pluck("short_title")) %>% unname(),
                   overlayGroups = c("Schools", "Parks", "Food Stores"),
                   position = "bottomright",
                   options = layersControlOptions(collapsed = F)) %>%
  hideGroup(c("Schools", "Parks", "Food Stores")) %>%
  setMaxBounds(-80, 35, -78, 37)

exploremap <- exploremap %>%
  addCircleMarkers(data = food_stores,
                   lat = ~lat, lng = ~lon, popup = ~name,
                   stroke = TRUE, fillOpacity = 0.075,
                   group = "Food Stores") %>%
  addMarkers(data = schools,
             lat = ~lat, lng = ~lng, popup = ~school,
             clusterOptions = markerClusterOptions(),
             group = "Schools") %>%
  addMarkers(data = parks,
             lat = ~lat, lng = ~lon, popup = ~name,
             clusterOptions = markerClusterOptions(),
             group = "Parks")

#Shiny legend adding
shiny_observe_input <- "Black Population" #testing

exleg <- explore_legend %>% filter(group == shiny_observe_input)

exploremap %>% addLegend(pal = exleg$palette[[1]],
                         values = c(exleg$minval, exleg$maxval),
                         labFormat = exleg$exp_labformat[[1]],
                         position = "bottomleft",
                         title = exleg$group,
                         group = exleg$group)


# From github:
# serveEvent(input$mymap_groups,{
#   leafletProxy('mymap') %>% removeControl(layerId = "basegroup_legend_1") %>% removeControl(layerId = "basegroup_legend_2")
#
#   if ('basegroup_layer_1' %in% isolate(input$mymap_groups)){
#     leafletProxy('mymap') %>% addLegend(position = "bottomright",
#                                         colors = c("#269900","#ff0000"),
#                                         labels = c('Discrete label 1','Discrete label 2'),
#                                         layerId = "basegroup_legend",
#                                         title='Legend title')
#   }
#   else if ('basegroup_layer_2' %in% isolate(input$mymap_groups)){
#     leafletProxy('mymap') %>% addLegend(position = "bottomright",
#                                         colors = c("#269900","#ff0000"),
#                                         labels = c('Discrete label 1','Discrete label 2'),
#                                         layerId = "basegroup_legend_2",
#                                         title='Legend title')
#   }
# })

exploremap

write_rds(exploremap, "~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/exploremap.rds")

exploremap %>% htmlwidgets::onRender("
                      function(el, x) {
                      this.on('baselayerchange', function(e) {
                      e.layer.bringToBack();
                      })
                      }
                      ")

exploremap %>%
  htmlwidgets::onRender("
                        function(el, x) {
                          this.on('baselayerchange', function(e) {
                            e.")


# Change Map ------------------------------------------------------------------------------------------------------
comparemap <- leaflet()

walk(explore_acsdata, function(layer) {

  est_column_year1 <- sym(paste0("est", shiny_selected_year1))
  est_column_year2 <- sym(paste0("est", shiny_selected_year2))

  layer <- layer %>%
    mutate(estimate = !!est_column_year2 - !!est_column_year1)

  #Build palette
  palette <- colorNumeric(
    palette = "RdYlGn",
    domain = layer$estimate
  )

  group <- layer %>% slice(1) %>% pull(short_title)

  popup <- layer %>%
    transmute(popup = glue("<B>{concept}</B><BR><BR>
                           Change from {shiny_selected_year1} to {shiny_selected_year2}: {format(estimate, big.mark = ',')}")) %>%
    pull(popup)

  #str_replace_all(str_wrap(concept, width = 20, exdent = 3), '\n', '<BR>')


  comparemap <<- comparemap %>%
    #addTiles(options = tileOptions(minZoom = 5), group = group) %>%
    setMaxBounds(-84, 35, -79, 37) %>%
    addPolygons(data = layer,
                group = group,
                stroke = F,
                fillColor = ~palette(estimate),
                fillOpacity = 0.7,
                popup = popup
    ) #%>%
  # addLegend(pal = palette,
  #           values = layer$estimate,
  #           group = group,
  #           position = "bottomleft",
  #           title = group
  #           )



})

comparemap <- comparemap %>%
  addTiles(options = tileOptions(minZoom = 5)) %>%
  addLayersControl(baseGroups = explore_acsdata %>% map_chr(~.x %>% slice(1) %>% pluck("short_title")) %>% unname(),
                   overlayGroups = c("Schools", "Parks", "Food Stores"),
                   position = "bottomright",
                   options = layersControlOptions(collapsed = F)) %>%
  hideGroup(c("Schools", "Parks", "Food Stores")) %>%
  addLegend(pal = colorNumeric(palette = "RdYlGn", domain = c(-1,1)),
            values = c(-1, 1),
            position = "bottomleft",
            title = "Scale"
  )

comparemap <- comparemap %>%
  addCircleMarkers(data = food_stores,
                   lat = ~lat, lng = ~lon, popup = ~name,
                   stroke = TRUE, fillOpacity = 0.075,
                   group = "Food Stores") %>%
  addMarkers(data = schools,
             lat = ~lat, lng = ~lng, popup = ~school,
             clusterOptions = markerClusterOptions(),
             group = "Schools") %>%
  addMarkers(data = parks,
             lat = ~lat, lng = ~lon, popup = ~name,
             clusterOptions = markerClusterOptions(),
             group = "Parks")

comparemap



# Timelines -------------------------------------------------------------------------------------------------------

#Drop geo data and go long!
long_explore_acsdata <- explore_acsdata %>%
  map(function(table) {
    table %>%
      as_tibble() %>%
      select(-geometry) %>%
      gather(key = year, value = estimate, matches("est\\d{4}")) %>%
      mutate(year = parse_number(year))
  }) %>% bind_rows()

shiny_selected_table <- "Median Household Income"
shiny_selected_geoid <- "370810101001"

#Chart for the specific geoid
long_explore_acsdata %>%
  filter(short_title == shiny_selected_table,
         geoid == shiny_selected_geoid) %>%
  ggplot(aes(x = year, y = estimate)) +
  geom_col() +
  scale_y_continuous(labels = scale_si_unit()) +
  labs(x = "Year", y = "Estimate") +
  ggtitle(shiny_selected_table)












# Comparison to county level data ---------------------------------------------------------------------------------

county_explore_acsdata <- explore_tables %>%
  group_split(table) %>%
  future_map(function(table) {
    #First get the most recent year with the geometry attached
    geo_table <- si_acs(table$table, geography = "county", year = most_recent_acs_year, county = "Guilford County", state = "NC", geometry = T) %>%
      st_transform(crs = "+init=epsg:4326") %>%
      add_column(short_title = table$short_title) %>%
      rename(!!paste0("est", most_recent_acs_year) := estimate) %>%
      select(-moe, -year, -matches("Total")) #some tables may not have a Total, so this "matches" avoids an error


    #Now get the rest without geometry and attach to the table with geometry
    data_tables <- map(explore_years, function(explore_years) {
      si_acs(table$table, geography = "county", year = explore_years, county = "Guilford County", state = "NC", geometry = F) %>%
        rename(!!paste0("est", explore_years) := estimate) %>%
        select(-moe, -year, -matches("Total")) #some tables may not have a Total, so this "matches" avoids an error
    }) %>%
      reduce(left_join)

    combined_table <- left_join(geo_table, data_tables)

    return(combined_table)
  }, .progress = T) %>%
  map(function(table) {
    table %>%
      as_tibble() %>%
      select(-geometry) %>%
      gather(key = year, value = estimate, matches("est\\d{4}")) %>%
      mutate(year = parse_number(year))
  }) %>% bind_rows()

long_explore_acsdata %>%
  left_join(county_explore_acsdata %>% select(variable, year, estimate))




geom_errorbar(aes(y = bars1, ymin = bars1, ymax = bars1), color="Orange",lty=2)


long_explore_acsdata %>%
  filter(short_title == shiny_selected_table,
         geoid == shiny_selected_geoid) %>%
  ggplot(aes(x = year, y = estimate)) +
  geom_col() +
  geom_errorbar(data = county_explore_acsdata %>%
            filter(short_title == shiny_selected_table),
         aes(ymin = estimate, ymax = estimate), color = "blue", lty = 2) +
  scale_y_continuous(labels = scale_si_unit()) +
  labs(x = "Year", y = "Estimate") +
  ggtitle(shiny_selected_table)



