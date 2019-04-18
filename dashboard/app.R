library(shiny)
library(shinydashboard)


# Load data ---------------------------------------------------------------

load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/ages.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/race.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/ethnicity.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/sex.rda")


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
        
      )
      ),
    
    # CIVIC Tab ----
    
    tabItem(
      tabName = "civic",
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
                       box(
                         width = NULL,
                         valueBoxOutput("total_population", width = NULL)
                       )),
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
          box(
            width = NULL, 
            billboarderOutput("race")
          )
        ), 
        column(
          6, 
          box(
          width = NULL, 
          billboarderOutput("ethnicity")
        ))
      )
    ),
    
    # LIVE Tab ----
    
    tabItem(
      tabName = "live",
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
      br(),
      
      fluidRow(),
      
      
      fluidRow(column(
        10,
        offset = 1,
        align = "center",
        box(width = NULL,
            h1("Birth charts here"))
      )),
      
      
      fluidRow(
        column(
          6, 
          align= "center", 
          h2("Health 1 chart")
        ),
        column(
          6,
          align = "center",
          h2("Health 2 chart")
        )
        
      ), 
      
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
    ),
    
    # WORK Tab ----
    
    
    tabItem(
      tabName = "work",
      fluidRow(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
      ),
      fluidRow(),
      fluidRow()
    ),
    
    # PLAY Tab ----
    
    tabItem(
      tabName = "play",
      fluidRow(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
      ),
      fluidRow(),
      fluidRow()
    ),
    
    #LEARN Tab ----
    
    tabItem(
      tabName = "learn",
      fluidRow(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
      ),
      fluidRow(),
      fluidRow()
    ),
    
    # ACT Tab ----
    
    tabItem(
      tabName = "act",
      fluidRow(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
      ),
      fluidRow(),
      fluidRow()
    )
    
      )
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
  
}


# Run the app -------------------------------------------------------------

shinyApp(ui, server)
