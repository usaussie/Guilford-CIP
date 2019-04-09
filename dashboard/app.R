library(shiny)
library(shinydashboard)


# Define individual UI elements -------------------------------------------------------------

# Define the sidebar ----

sidebar <- dashboardSidebar(
  sidebarMenu(
              menuItem("Overview", tabName = "overview"),
              menuItem("Live", tabName = "live"),
              menuItem("Work", tabName = "work"),
              menuItem("Play",tabName = "play"),
              menuItem("Learn",tabName = "learn"),
              menuItem("Belong",tabName = "belong")
  )
)


# Define the body ---- 

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "mystyle.css")
  ),
  
  # Start Tabs ----
  tabItems(
    
    # Tab for Description of the project----
    tabItem(tabName = "overview",
            fluidRow(
              column(12
              )
            )),
    
    
    tabItem(tabName = "live",
            fluidRow(),
            fluidRow(),
            
            fluidRow(),
            
            
            fluidRow()),
    
   
    tabItem(tabName = "work",
            fluidRow(),
            fluidRow(),
            fluidRow()
    ),
    
    tabItem(tabName = "play",
            fluidRow(),
            fluidRow(),
            fluidRow()
    ),
    
    tabItem(tabName = "learn",
            fluidRow(),
            fluidRow(),
            fluidRow()
    ),
    
    tabItem(tabName = "belong",
            fluidRow(),
            fluidRow(),
            fluidRow()
    )
    
  ))



# Define the UI ---------------------------------------------------------

ui <- dashboardPage(title = "Guilford CIP", skin = "black",
                    dashboardHeader(title = "Guilford Community Indicators"),
                    sidebar,
                    body
)



# Define the server -----------------------------------------------------

server <- function(input, output) {
  
}


# Run the app -------------------------------------------------------------

shinyApp(ui, server)

