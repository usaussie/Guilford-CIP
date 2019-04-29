library(leaflet)
library(shiny)

death <- read_rds("~/Google Drive File Stream/My Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_addresses_geocoded.rds")

ui <- fluidPage(
  leafletOutput("death_map")
  )

server <- function(input, output, session) {
  output$death_map <- renderLeaflet({
  leaflet(data = death) %>%
    addTiles() %>%
    addCircleMarkers(lat = ~location.y, lng = ~location.x, popup = ~full_address)
  })
}

shinyApp(ui, server)
  