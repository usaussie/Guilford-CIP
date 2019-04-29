library(leaflet)
library(shiny)

parks <- read_rds("~/Google Drive File Stream/My Drive/SI/DataScience/data/Guilford County CIP/Parks/parks full lst.rds")
parks1 <- do.call(rbind, lapply(parks, data.frame, stringsAsFactors=FALSE))

ui <- fluidPage(
  leafletOutput("parks_map")
)

server <- function(input, output, session) {
  output$parks_map <- renderLeaflet({
    leaflet(data = parks1) %>%
      addTiles() %>%
      addMarkers(lat = ~lat, lng = ~lon, popup = ~name,
                 clusterOptions = markerClusterOptions())
  })
}

shinyApp(ui, server)
