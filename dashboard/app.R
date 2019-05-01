library(shiny)
library(shinydashboard)
library(billboarder)
library(tidyverse)
library(leaflet)


# Load data ---------------------------------------------------------------

load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/ages.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/race.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/ethnicity.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/sex.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/emp_race.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/age.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/med_income.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/vacant_housing.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/geo_places.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/hh_race.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/life_expectancy.rda")


# Define individual UI elements -------------------------------------------------------------

# Define the sidebar ----

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Overview", tabName = "overview", icon = icon("binoculars")),
    menuItem("Civic", tabName = "civic", icon = icon("chart-bar")),
    menuItem("Live", tabName = "live", icon = icon("home")),
    menuItem("Work", tabName = "work", icon = icon("briefcase")),
    menuItem("Play", tabName = "play", icon = icon("tree")),
    menuItem("Learn", tabName = "learn", icon = icon("graduation-cap")),
    menuItem("Act", tabName = "act", icon = icon("hands-helping"))
  ),
  sidebarSearchForm(
    label = "Search",
    "searchText",
    "searchButton",
    icon = shiny::icon("search")
  )
)


# Define the body ----

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "dashboard.css")
  ),
  
  # Start Tabs ----
  tabItems(
    # Tab for Description of the project----
    tabItem(
      tabName = "overview",
      tags$div(class = "overview-tab",
      fluidRow(column(
        12,
        align = "center",
        h1("GUILFORD COMMUNITY INDICATORS DASHBOARD")
      )),
      
      fluidRow(column(12,
                      align = "center",
                      box(
                        width = NULL,
                        h1("GUILFORD IMAGE")
                      ))),
      
      fluidRow(column(
        12,
        box(
          width = NULL,
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
      )),
      tags$div(class = "overview-icons",
        fluidRow(
            column(2,
                   box(
                     title = "CIVIC",
                     width = NULL,
                     icon("chart-bar", "fa-10x")
                   )),
            
            column(2,
                   box(
                     title = "LIVE",
                     width = NULL,
                     icon("home", "fa-10x")
                   )),
            column(2,
                   box(
                     title = "WORK",
                     width = NULL,
                     icon("briefcase", "fa-10x")
                   )),
            column(2,
                   box(
                     title = "PLAY",
                     width = NULL,
                     icon("tree", "fa-10x")
                   )),
            
            column(2,
                   box(
                     title = "LEARN",
                     width = NULL,
                     icon("graduation-cap", "fa-10x")
                   )),
            column(2,
                   box(
                     title = "ACT",
                     width = NULL,
                     icon("hands-helping", "fa-10x")
                   ))
            
            ) #End of the row
        ) #End of overview-icons class
      ) #End of the overview-tab class
    ), #--> End of Tab items
    
    # CIVIC Tab ----
  
    tabItem(
      tabName = "civic",
      tags$div(class = "civic-tab",
      fluidRow(column(12,
                      align = "center",
                      h1(
                        "CIVIC"
                      ))),
      fluidRow(column(12,
                      align = "center",
                      box(
                        width = NULL,
                        h1("Image here")
                      ))),
      fluidRow(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
      ),
      br(),
      
      fluidRow(column (2,
                       fluidRow(
                         box(
                           width = NULL,
                           valueBoxOutput("total_population", width = NULL)
                         )
                       ),
                       fluidRow(
                         box(
                           width = NULL,
                           valueBoxOutput("median_age", width = NULL)
                         )
                       ))
                       ,
               column(
                 5,
                 box(width = NULL, title = "Age Distribution in Guilford County",
                     billboarderOutput("age"))
               ),
               column(
                 5,
                 box(width = NULL,
                     title = "Males to Females in Guilford County",
                     billboarderOutput("sex"))
               )), 
      fluidRow(
        column(
          12,
          box(
            width = NULL,
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
             
          )
        )
      ), 
      
      fluidRow(
        column(
          6, 
          
          box( title = "Race",
            width = NULL, 
            billboarderOutput("race")
          )
        ), 
        column(
          6, 
          box( title = "Ethnicity",
          width = NULL, 
          billboarderOutput("ethnicity")
        ))
      )
    )),
    
    # LIVE Tab ----
    
    tabItem(
      tabName = "live",
      tags$div(class = "live-tab",
      fluidRow(column(12,
                      align = "center",
                      box(
                        width = NULL,
                        h1("Image here")
                      ))),
      fluidRow(
        column(
          12,
          box(width = NULL,
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
      ))),
      br(),
      br(),
      
      # fluidRow(
      #   column(
      #     width = 8, offset = 2,
      #     box(
      #       width = NULL,
      #       title = "Life Expectancy in Guilford County Compared to the State of North Carolina",
      #     uiOutput("le")
      #     )
      #     
      #   )
      # ),
      
   
      fluidRow(
        column(
          width = 8, 
          offset = 2, 
          h1("Life Expectancy in Guilford County Compared to the State of North Carolina")
        )
      ), 
      
      
      fluidRow(
        
        column(width = 2, offset = 2,  valueBoxOutput("le_males", width = NULL)), 
        column(width = 2, valueBoxOutput("le_fem", width = NULL)), 
        column(width = 2, valueBoxOutput("le_white", width = NULL)),
        column(width = 2, valueBoxOutput("le_afram", width = NULL))
        
        
      ),
      
      
      fluidRow(column(
        10,
        offset = 1,
        align = "center",
        box(width = NULL,
            h1("Birth charts here"))
      )),
      
      # fluidRow(
      #   column(
      #     6,
      #     align = "center", 
      #     box(
      #       title = "Life Expectancy in Guilford County and North Carolina by sex",
      #       width = NULL, 
      #       billboarderOutput("le_sex")
      #     )
      #   ),
      #   column(
      #     6,
      #     align = "center", 
      #     box(
      #       title = "Life Expectancy in Guilford County and North Carolina by race",
      #       width = NULL, 
      #       billboarderOutput("le_race")
      #     )
      #   )
      #   
      # ),
      
      
      fluidRow(
        column(
          3, 
          box(
            width = NULL,
            title = "Head of household by race/sex",
            billboarderOutput("hh_race")
          ) 
          
        ),
        column(
          9,
          box(
            width = NULL,
            title = "Health 2 chart"
            
          )
          )
        
        
      ), 
      fluidRow(
        
        column(8,
               offset = 2,
               box(width = NULL,
                 title = "Vacant Houses+ Permits?",
                 leafletOutput("vacant_houses_map")
               ))
        
      ),
      
      
      fluidRow(),
      
      
      fluidRow(
        column(
          8, 
          align = "center", 
          h2("Vacant houses map?")
        ), 
        
        column(
          4, 
          align = "center", 
          h2("Permits for remodel")
        )
      ), 
      
      fluidRow(
        column(12, 
               align = "center", 
               h2("Food Deserts Map"))
      ), 
      fluidRow(
        column(12, 
               align = "center", 
               h2("deaths"))
      )
    )),
    
    # WORK Tab ----
    
    
    tabItem(
      tabName = "work",
      tags$div(class = "work-tab",
      fluidRow(column(12,
                      align = "center",
                      box(
                        width = NULL,
                        h1("Image here")
                      ))),
      
      fluidRow(
        column(
          12, 
          box(
            width = NULL, 
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
            )
          )
      ),
      
      fluidRow(
        column(6, 
               align  ="center",
               box(
                 width = NULL, 
                 title = "Median Household Income by Race",
                 billboarderOutput("med_inc_race")
               )),
        column(5,
               box(
                 width = NULL, 
                 title = "Median Household Income by Ethnicity", 
                 billboarderOutput("med_inc_ethn")
               ))
      ),
      fluidRow(
        column(
          12, 
          box(
            width = NULL, 
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
          )
        )
      ),
      
      fluidRow(
        column(10,
               offset = 1,
               align = "center",
               
               box(width = NULL,
                   title = "Employment  Percentage (Civilian Labor Force) by Race and Sex",
                   billboarderOutput("emp_race"))
               )
      ),
      fluidRow(
        column(12,
               box(
                 "Means of transportation by race?"
               ))
      )
    )),
    
    # PLAY Tab ----
    
    tabItem(
      tabName = "play",
      tags$div(class = "play-tab",
      fluidRow(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
      ),
      fluidRow(),
      fluidRow()
    )),
    
    #LEARN Tab ----
    
    tabItem(
      tabName = "learn",
      tags$div(class = "learn-tab",
      fluidRow(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
      ),
      fluidRow(),
      fluidRow()
    )),
    
    # ACT Tab ----
    
    tabItem(
      tabName = "act",
      tags$div(class = "act-tab",
      fluidRow(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
      ),
      fluidRow(),
      fluidRow()
    )
    
      ))
      )



# Define the UI ---------------------------------------------------------

ui <- dashboardPage(
  title = "Guilford CIP",
  skin = "black",
  dashboardHeader(title = "Guilford Community Indicators"),
  sidebar,
  body
)



# Define the server -----------------------------------------------------

server <- function(input, output) {
  # Civic Tab ----
  
  output$total_population <- renderValueBox({
    total <- gc_sex %>%
      summarise(t = sum(estimate))
    
    valueBox(
      value = prettyNum(total, big.mark = ","),
      subtitle = "Total Population",
      color = "blue"
    )
    
  })
  
  
  output$median_age <- renderValueBox({
    med_age <- age %>% 
      filter(levlab == "Total") %>% 
      pull(estimate)
    
    valueBox(
      value = prettyNum(med_age, big.mark = ","),
      subtitle = "Median Age",
      color = "blue"
    )
  })
  
  output$age <- renderBillboarder({
    billboarder() %>%
      bb_barchart(data = gc_ages, stacked = T)
  })
  
  output$sex <- renderBillboarder({
    billboarder() %>%
      bb_donutchart(data = gc_sex)
    
  })
  
  output$race <- renderBillboarder({
    billboarder() %>% 
      bb_donutchart(data = race_county) %>% 
      bb_donut()
  })
  
  output$ethnicity <- renderBillboarder({
    billboarder() %>% 
      bb_donutchart(data = acs_ethn_county)
  })
  

  
  # LIVE Tab ----
  
  output$le_males <- renderValueBox({
    value <- life_expectancy%>% 
      filter(key == "males") %>% 
      mutate(diff = (`Guilford County`- `State of North Carolina`)*12) %>% 
      mutate(diff = round(diff,0)) %>% 
      pull (diff)
    
    valueBox(paste0(value, " Mo"), "Men", icon = icon("arrow-up"), color= "orange")
    
  })
  
  output$le_fem <- renderValueBox({
    value <- life_expectancy%>% 
      filter(key == "females") %>% 
      mutate(diff = (`Guilford County`- `State of North Carolina`)*12) %>% 
      mutate(diff = round(diff,0)) %>% 
      pull (diff)
    
    valueBox(paste0(value, " months"), "Women", icon = icon("arrow-up"), color= "orange")
  })
  
  
  output$le_white <- renderValueBox({
    value <- life_expectancy%>% 
      filter(key == "white") %>% 
      mutate(diff = (`Guilford County`- `State of North Carolina`)*12) %>% 
      mutate(diff = round(diff,0)) %>% 
      pull (diff)
    
    valueBox(paste0(value, " months"), "Race: White", icon = icon("arrow-up"), color= "orange")
  })
  
  output$le_afram <- renderValueBox({
    value <- life_expectancy%>% 
      filter(key == "african_american") %>% 
      mutate(diff = (`Guilford County`- `State of North Carolina`)*12) %>% 
      mutate(diff = round(diff,0)) %>% 
      pull (diff)
    
    valueBox(paste0(value, " months"), "Race: African American", icon = icon("arrow-up"), color= "orange")
  })
  

  
  # output$le <- renderText({
  #   
  #   fem_le <- life_expectancy%>% 
  #     filter(key == "females") %>% 
  #     mutate(diff = (`Guilford County`- `State of North Carolina`)*12) %>% 
  #     mutate(diff = round(diff,0)) %>% 
  #     pull (diff)
  #   
  #   males_le <- life_expectancy%>% 
  #     filter(key == "males") %>% 
  #     mutate(diff = (`Guilford County`- `State of North Carolina`)*12) %>% 
  #     mutate(diff = round(diff,0)) %>% 
  #     pull (diff)
  #   
  #   white_le <- life_expectancy%>% 
  #     filter(key == "white") %>% 
  #     mutate(diff = (`Guilford County`- `State of North Carolina`)*12) %>% 
  #     mutate(diff = round(diff,0)) %>% 
  #     pull (diff)
  #   
  #   afram_le <- life_expectancy%>% 
  #     filter(key == "african_american") %>% 
  #     mutate(diff = (`Guilford County`- `State of North Carolina`)*12) %>% 
  #     mutate(diff = round(diff,0)) %>% 
  #     pull (diff)
  #   
  #   paste('<b><span style="color:#e54b21;font-size:45px;">', males_le, '</span>',    
  #         '<b><span style="color:#AC492E;font-size:30px;"> MONTHS HIGHER </span>',
  #         '<span style="color:#e54b21;font-size:45px;"> &nbsp; &nbsp;|&nbsp; &nbsp;' ,fem_le ,'</span>',    
  #         '<b><span style="color:#AC492E;font-size:30px;"> MONTHS HIGHER </span>',
  #         '<span style="color:#e54b21;font-size:45px;"> &nbsp; &nbsp;|&nbsp; &nbsp;' ,white_le ,'</span>',    
  #         '<b><span style="color:#AC492E;font-size:30px;"> MONTHS HIGHER </span>',
  #         '<span style="color:#e54b21;font-size:45px;"> &nbsp; &nbsp;|&nbsp; &nbsp;' ,afram_le ,'</span>',    
  #         '<b><span style="color:#AC492E;font-size:30px;"> MONTHS HIGHER </span>')
  #   
  # })
  
  # output$le_sex <- renderBillboarder({
  #   
  #   le_sex <- life_expectancy %>% 
  #     filter(key == "males"|key == "females")
  #   
  #   billboarder() %>% 
  #     bb_barchart(data = le_sex)
  # })
  # 
  # 
  # output$le_race <- renderBillboarder({
  #   
  #   le_race <- life_expectancy %>% 
  #     filter(key == "white"|key =="african_american")
  #   
  #   billboarder() %>% 
  #     bb_barchart(data = le_race)
  # })
  
  output$hh_race <- renderBillboarder({
    
    billboarder() %>% 
      bb_donutchart(data = hh_race)
    
  })
    
  output$vacant_houses_map <- renderLeaflet({
    
    pal <- colorQuantile(palette = "viridis", domain = vacant_housing$estimate,  probs = seq(0, 1, 0.1))
    
    vacant_housing %>% 
      leaflet() %>% 
      addProviderTiles(providers$Esri.WorldTopoMap) %>% 
      addPolygons(
        stroke = F,
        
        fillColor = ~pal(estimate), 
        fillOpacity = 0.7
      ) %>%  
      addPolygons(data = geo_places,
                  stroke = T, weight = 1,
                  label = ~ NAME, 
                  color = "white", 
                  dashArray = "3"
      ) %>% 
      addLegend("bottomright",
                pal = pal,
                values = ~ estimate,
                title = "Vacant Houses",
                opacity = 1)
  })
  

  # WORK Tab ----
  
  output$emp_race <- renderBillboarder({
    billboarder() %>% 
      bb_barchart(data = emp_race)
  })
  
  output$med_inc_race <- renderBillboarder({
    med_income_race <- med_income %>% 
      filter(race!="White Alone, Not Hispanic or Latino") %>% 
      filter(race!="Hispanic or Latino") %>% 
      select(race, estimate)
    
    billboarder() %>% 
      bb_barchart(data = med_income_race)
  })
  
  output$med_inc_ethn <- renderBillboarder({
    
    med_income_ethn <- med_income %>% 
      filter(race=="White Alone, Not Hispanic or Latino"| race =="Hispanic or Latino" ) %>% 
      select(race, estimate)
    
    billboarder() %>% 
      bb_barchart(data = med_income_ethn)
  })
  
}


# Run the app -------------------------------------------------------------

shinyApp(ui, server)
