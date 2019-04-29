library(leaflet)
library(shiny)

schools <- read_rds("~/Google Drive File Stream/My Drive/SI/DataScience/data/Guilford County CIP/Parks/schools full lst.rds")
schools1 <- do.call(rbind, lapply(schools, data.frame, stringsAsFactors=FALSE))

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
