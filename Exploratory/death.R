library(leaflet)
library(shiny)

death <- read_rds("~/Google Drive File Stream/My Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_addresses_geocoded.rds")

acsvars <- load_variables(2017, "acs5", cache = T) %>%
  mutate(level = str_count(label, pattern = "!!")) %>%
  rowwise() %>%
  mutate(levlab = str_split(label, pattern = "!!") %>% unlist() %>% .[level + 1]) %>%
  ungroup() %>%
  mutate(concept = str_to_title(concept)) %>%
  dplyr::rename(variable = name)

si_acs <- function(table, county = NULL, state = NULL, summary_var = "universe total", geography = NULL, survey = NULL) {
  cat(yellow(bold("Reminder: You must stay within the same level for any summary to be valid!\n")))
  
  if(summary_var == "universe total") summary_var = paste0(table, "_001")
  summary_label = acsvars %>% filter(variable == summary_var) %>% pull(levlab)
  
  get_acs(geography = geography,
          table = table,
          county = county,
          state = state,
          output = "tidy",
          year = 2017,
          cache_table = T,
          summary_var = summary_var, 
          geometry = TRUE, 
          cb = TRUE, 
          survey = survey) %>%
    clean_names() %>%
    left_join(acsvars) %>%
    select(-summary_moe, -variable) %>%
    select(geoid, county = name, level, levlab, estimate, everything()) %>%
    rename(!!summary_label := summary_est)
}

base_death <- si_acs("B02001", survey = "acs5", geography = "tract", state = "NC") %>%
  filter(levlab != "Total")

ui <- fluidPage(
  leafletOutput("death_map")
  )

server <- function(input, output, session) {
  pal <- colorQuantile(palette = "viridis", domain = base_death$estimate, probs = seq(0, 1, 0.1))
  output$death_map <- renderLeaflet({
    leaflet(data = death) %>%
    addTiles() %>%
    addMarkers(lat = ~location.y, lng = ~location.x,
                clusterOptions = markerClusterOptions())%>%
    addPolygons(data = base_death,
        stroke = F,
        fillColor = ~pal(estimate),
        fillOpacity = 1
    )
  })
}

shinyApp(ui, server)
  
