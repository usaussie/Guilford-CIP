library(leaflet)
library(shiny)

#schools <- read_rds("~/Google Drive File Stream/My Drive/SI/DataScience/data/Guilford County CIP/Parks/schools full lst.rds")
schools <- read_rds("G:/My Drive/SI/DataScience/data/Guilford County CIP/Parks/schools full lst.rds")

schools1 <- do.call(rbind, lapply(schools, data.frame, stringsAsFactors=FALSE))

schools1 <- schools1 %>% 
  distinct(id, .keep_all = T)


save(schools1, file = "G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/schools.rda")


leaflet(data = schools2) %>%
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
