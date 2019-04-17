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
  ),
  sidebarSearchForm(label = "Search", "searchText", "searchButton", icon = shiny::icon("search"))
)


# Define the body ---- 

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "dashboard.css")
  ),

  # Start Tabs ----
  tabItems(
    
    # Tab for Description of the project----
    tabItem(tabName = "overview",
            fluidRow(
              column(12,
                    align = "center",
                    h1("TITLE")
                     )
            ),
            
            fluidRow(
              column(12,
                     align = "center",
                     box(
                       width = NULL, 
                       h1("IMAGE")
                     )
              )
            ),
            
            fluidRow(
              column(12,
                     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
                     
              )
            ),
            
            fluidRow(
              
              column(2, 
                     offset = 1,
                     box(
                       title = "LIVE",
                       width =NULL, 
                       icon("home", "fa-10x")
                     )),
              column(
                2, 
                box(
                  title = "WORK",
                  width =NULL, 
                  icon("briefcase", "fa-10x")
                )
              ),
              column(
                2, 
                box(
                  title = "PLAY",
                  width =NULL, 
                  icon("tree", "fa-10x")
                )
              ),
              
              
            )),
    
    
    tabItem(tabName = "live",
            fluidRow(
              column(12,
                     align = "center",
                     box(
                       width = NULL, 
                       h1("Image here")
                     ))
            ),
            fluidRow("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
            br(),
            br(),
            fluidRow(
              column(10, 
                     offset = 1, 
                     align = "center",
                     box(width = NULL, 
                         h1("Birth charts here")))
            ),
            
            
            fluidRow()),
    
   
    tabItem(tabName = "work",
            fluidRow("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
            fluidRow(),
            fluidRow()
    ),
    
    tabItem(tabName = "play",
            fluidRow("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
            fluidRow(),
            fluidRow()
    ),
    
    tabItem(tabName = "learn",
            fluidRow("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
            fluidRow(),
            fluidRow()
    ),
    
    tabItem(tabName = "belong",
            fluidRow("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
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

