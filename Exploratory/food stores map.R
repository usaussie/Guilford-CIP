library(leaflet)
library(shiny)

food_stores <- read_rds("~/Google Drive File Stream/My Drive/SI/DataScience/data/Guilford County CIP/Food Stores/food stores full lst.rds")
food_stores1 <- do.call(rbind, lapply(food_stores, data.frame, stringsAsFactors=FALSE))

ui <- fluidPage(
  leafletOutput("food_stores_map")
)

server <- function(input, output, session) {
  output$food_stores_map <- renderLeaflet({
    leaflet(data = food_stores1) %>%
      addTiles() %>%
      addCircleMarkers(lat = ~lat, lng = ~lon, popup = ~name,
                       stroke = FALSE, fillOpacity = 0.2
                 )
  })
}

shinyApp(ui, server)
