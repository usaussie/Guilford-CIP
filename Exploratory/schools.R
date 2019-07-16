library(leaflet)
library(leaflet.extras)
library(shiny)

schools <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/schools.rds")


leaflet(data = schools) %>%
  addTiles() %>%
  addMarkers(lat = ~lat, lng = ~lon, popup = ~name,
             clusterOptions = markerClusterOptions())



ui <- fluidPage(
  leafletOutput("schools_map")



)

server <- function(input, output, session) {
  output$schools_map <- renderLeaflet({
    leaflet(data = schools1) %>%
      addTiles() %>%
      addMarkers(lat = ~lat, lng = ~lon, popup = ~name,
                 clusterOptions = markerClusterOptions())
  })
}

shinyApp(ui, server)
