library(shiny)
library(shinythemes)
library(billboarder)
library(tidyverse)
library(leaflet)
library(plotly)
library(sf)



# Load data ---------------------------------------------------------------

load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/ages.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/race.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/ethnicity.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/sex.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/emp_race.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/age.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/med_income.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/vacant_housing.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/geo_places.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/hh_race.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/life_expectancy.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/ipeds.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/births.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/weather.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/transportation.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/voters.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/deaths.rda")
load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/tourism.rda")
projects <-read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/projects.csv")
death <-read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_addresses_geocoded.rds")
schools <-read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/schools.rds")
food_stores <-read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/food_stores.rds")
parks <-read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/parks.rds")
projects_txt <- file("./data/projects_act.txt")



# Define individual UI elements -------------------------------------------

# Define the sidebar ----

# Define the body ----

body <- mainPanel(
  fluidRow(
    column(10, offset = 1, 
           "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien.")
  ), 
  br(),
  br(),
    tabsetPanel(
        type = "tabs", 
        
        # Overview Tabs ----
        
        tabPanel(
        
            title = "Overview", icon = icon("binoculars"), 
            tags$div(class = "overview-tab",
                     br(),
                     
                     fluidRow(column(
                         12,
                         img(src = "./Images/overview.png", class = "bannerImg")
                         
                     )),
                     br(),
                     
                     fluidRow(
                         column(
                             12,
                             "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et
          dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada
          proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna.
          Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non
          curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum
          tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas.
          Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique.
          Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar
          sapien."
                             
                         )
                     ))
        ),
        
        # Civic Tab ----
        tabPanel(
            title = "Civic",icon = icon("chart-bar"),
            tags$div(
                class = "civic-tab",
                fluidRow(
                    column(
                        12, 
                        img(src = "./Images/civic.png", class = "bannerImg")
                    )
                ), 
                br(),
                fluidRow(
                    column(
                        12,
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                        
                    )
                ), 
                fluidRow(
                    column(
                        2,
                        img(src = "./Images/pop_age.png", class = "popAge")
                    ),
                    column(
                        5, 
                        billboarderOutput("age")
                    ),
                    column(
                        5, 
                        billboarderOutput("sex")
                    )
                ), 
                fluidRow(
                    column(
                        6,
                        billboarderOutput("race")
                    ), 
                    column(
                        6, 
                        billboarderOutput("ethnicity")
                    )
                )
                
            )
        ),
        
        # Live Tab -----
        tabPanel(title = "Live", icon = icon("home"),
                 tags$div(class = "live-tab",
                          fluidRow(column(12,
                                          img(src = "./Images/live.png", class = "bannerImg"))),
                          
                          fluidRow(
                            column(12,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                            )),
                          
                          fluidRow(
                            column(
                              12,
                              h1("PEOPLE")
                            )
                          ),
                         
                          fluidRow(
                            column(
                              12,

                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                              )),
                     
                          fluidRow(
                            column(
                              4,
                              offset  = 1,

                                img(src = "./Images/life_expectancy.png", class = "leInfo")

                            ),

                            column(
                              5,

                                  img(src = "./Images/live01.jpg", class = "live01")

                            )
                          ), 
                         
                          fluidRow(
                            column(
                              4,

                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Vitae ultricies leo integer malesuada nunc. Bibendum enim facilisis gravida neque convallis. Ac felis donec et odio pellentesque diam volutpat commodo sed. Rhoncus est pellentesque elit
                                  ullamcorper dignissim cras tincidunt lobortis feugiat."
                            ),
                            column(
                              8,

                                plotlyOutput("birth2")

                            )
                          ), 
                          
                          fluidRow(
                            column(
                              width = 8,
                              offset = 2,
                              h1("Life Expectancy in Guilford County Compared to the State of North Carolina")
                            )
                          ),
                          
                          fluidRow(
                            column(12,

                                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Eget arcu dictum varius duis at consectetur lorem donec massa. Ut consequat semper viverra nam libero justo laoreet sit amet. Egestas congue quisque egestas diam in arcu. Suspendisse potenti nullam ac tortor vitae purus. At ultrices mi tempus imperdiet nulla malesuada pellentesque."
                                   )
                          ),
                         
                          fluidRow(
                            column(12,

                                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Lectus urna duis convallis convallis tellus id interdum. Ligula ullamcorper malesuada proin libero nunc consequat interdum varius sit."

                                   )
                          ), 
                          
                          fluidRow(
                            column(
                              7,

                                billboarderOutput("deaths")


                            ),
                            column(
                              5,

                                billboarderOutput("hh_race")

                            )

                          ),

                          fluidRow(
                            column(
                              12,

                                h1("PLACES")

                            )
                          ),

                          fluidRow(
                            column(12,

                                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Eget arcu dictum varius duis at consectetur lorem donec massa. Ut consequat semper viverra nam libero justo laoreet sit amet. Egestas congue quisque egestas diam in arcu. Suspendisse potenti nullam ac tortor vitae purus. At ultrices mi tempus imperdiet nulla malesuada pellentesque."
                                   )
                          ),

                          fluidRow(
                            column(
                              5,

                                  img(src = "./Images/live02.jpg", class = "live02")


                            ),

                            column(7,

                                       leafletOutput("food_stores_map")


                            )
                          ),

                          fluidRow(

                            column(
                              8,
                              offset = 2,

                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien.",
                                  leafletOutput("vacant_houses_map")


                            )


                          ),


                          fluidRow(
                            column(6,
                                   "Community Projects"
                                   ),
                            column(6,
                                   "Resources"
                                   )
                          )
                 )),
        tabPanel(title = "Work", icon = icon("briefcase")),
        tabPanel(title = "Play", icon = icon("tree")),
        tabPanel(title = "Learn", icon = icon("graduation-cap")),
        tabPanel(title = "Act", icon = icon("handshake"))
    )
)



# Define the UI -----------------------------------------------------------

ui <- fluidPage(theme = "sdashboard.css",
                titlePanel(title = div(
                    img(src = './Images/guilford-logo.png', class = "logoImg")
                )),
                body)


# Define the server -------------------------------------------------------
server <- function(input, output) {

  # CIVIC Tab ----
    
    
    
    output$age <- renderBillboarder({
        billboarder() %>%
            bb_lollipop(data = gc_ages, point_size = 5, point_color = "#617030", line_color = "#617030") %>%
            bb_axis(x =list(height = 80))
        #bb_barchart(data = gc_ages, stacked = T)
    })
    
    output$sex <- renderBillboarder({
        billboarder() %>%
            bb_donutchart(data = gc_sex) %>%
            bb_color(palette = c("#113535", "#CB942B", "#89ada7"))
        
        
    })
    
    output$race <- renderBillboarder({
        billboarder() %>%
            bb_donutchart(data = race_county) %>%
            bb_donut() %>%
            bb_color(palette = c("#617030", "#CB942B", "#89ada7", "#AC492E", "#071A1E", "#026637", "#113535"))
        
    })
    
    output$ethnicity <- renderBillboarder({
        billboarder() %>%
            bb_donutchart(data = acs_ethn_county) %>%
            bb_color(palette = c("#AC492E", "#113535", "#CB942B"))
        
    })
    
}


# LIVE Tab ----


# output$deaths <- renderBillboarder({
#   deaths_un <- deaths %>% filter(manner== "Accident"|manner == "Homicide"| manner == "Suicide"| manner == "Unknown")
#   
#   billboarder() %>%
#     bb_barchart(data = deaths_un) %>%
#     bb_y_axis(tick = list(format = suffix("%"))) %>%
#     bb_color(palette = c("#ac492e", "#113535", "#88853b", "#3a7993"))
#   
#   
# })
# 


# output$birth2 <- renderPlotly({
# 
#   plot_ly(data = births, x =~yob, y = ~Females, type = 'scatter', mode = 'lines+markers',
#           line= list(color= '#113535', width =2.5),
#           marker = list(color= '#113535', width =3),
#           name = 'Females') %>%
#     add_trace(y=~Males, line = list(color='#CB942B'),
#               marker = list(color= '#CB942B'),
#               name = 'Males') %>%
#     layout(yaxis = list(title = "", separatethousands = TRUE),
#            xaxis = list(title = "", tickangle = 45, tickfont = list(size = 10)),
#            legend = list(orientation = 'h', y = -0.2, x = 0.2))
# })


# 
# 
# 
# output$hh_race <- renderBillboarder({
#   
#   billboarder() %>%
#     bb_donutchart(data = hh_race) %>%
#     bb_color(palette = c("#E54B21", "#113535", "#617030", "#CB942B", "#89ada7", "#AC492E", "#071A1E", "#026637"))
#   
#   
# })
# 
# output$vacant_houses_map <- renderLeaflet({
#   
#   #pal <- colorQuantile(palette = "viridis", domain = vacant_housing$estimate,  probs = seq(0, 1, 0.1))
#   vacant_housing <- vacant_housing %>%
#     mutate(percent = estimate/Total) %>%
#     mutate(percent = ifelse(is.nan(percent), 0, percent)) %>%
#     st_transform(crs = "+init=epsg:4326")
#   
#   pal <- colorNumeric(palette = "viridis",   domain = vacant_housing$percent)
#   
#   
#   leaflet(data = vacant_housing) %>%
#     addTiles(options = tileOptions(minZoom = 5)) %>%
#     setMaxBounds(-84, 35, -79, 37) %>%
#     addPolygons(
#       stroke = F,
#       fillColor = ~pal(percent),
#       fillOpacity = 0.7
#     ) %>%
#     addPolygons(data = geo_places,
#                 stroke = T, weight = 1,
#                 label = ~ NAME,
#                 color = "white",
#                 dashArray = "3"
#     ) %>%
#     addLegend("bottomright",
#               pal = pal,
#               values = ~ percent,
#               labFormat = labelFormat(transform = function(x) 100*x, suffix = "%"),
#               title = "Vacant Houses",
#               opacity = 1)
# })
# 
# output$food_stores_map <- renderLeaflet({
#   leaflet(data = food_stores) %>%
#     addTiles(options = tileOptions(minZoom = 5)) %>%
#     setMaxBounds(-84, 35, -79, 37) %>%
#     addCircleMarkers(lat = ~lat, lng = ~lon, popup = ~name,
#                      stroke = TRUE, fillOpacity = 0.075)
# })




# Run the app -------------------------------------------------------------
shinyApp(ui, server)
