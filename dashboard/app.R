library(shiny)
library(shinydashboard)
library(billboarder)
library(tidyverse)
library(leaflet)
library(plotly)

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
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/births.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/weather.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/ipeds.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/transportation.rda")
load("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/voters.rda")
schools <- read_rds("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/schools.rds")
parks <- read_rds("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/parks.rds")
food_stores <- read_rds("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/food_stores.rds")
projects <- read_csv("G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/projects.csv")
death <- read_rds("G:/My Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_addresses_geocoded.rds")

# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/ages.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/race.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/ethnicity.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/sex.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/emp_race.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/age.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/med_income.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/vacant_housing.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/geo_places.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/hh_race.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/life_expectancy.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/ipeds.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/births.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/weather.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/transportation.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/voters.rda")
# projects <- read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/projects.csv")
# death <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_addresses_geocoded.rds")
# schools <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/schools.rds")
# food_stores <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/food_stores.rds")
# parks <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/parks.rds")


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
    menuItem("Act", tabName = "act", icon = icon("handshake"))
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
    tags$link(rel = "stylesheet", type = "text/css", href = "dashboard.css"),
    tags$script(src="scripts/myscript.js")
  ),

  # Start Tabs ----
  tabItems(
    # OVERVIEW Tab ----
    tabItem(
      tabName = "overview",
      tags$div(
        class = "overview-tab",
      fluidRow(
        column(12,
               align = "center",
               img(src = "/images/guilford-logo.png", class = "logoImg"))
      ),
      
      fluidRow(column(
        12,
        box(
          width = NULL,
          img(src = "/images/overview.png", class = "bannerImg")
        )
      )),

      fluidRow(column(
        12,
        box(class = "boxText",
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
                   tags$div(class="box-link",
                   tags$a(href = "#shiny-tab-civic", "data-toggle"="tab", "data-value"="civic",
                   box(
                     title = "CIVIC",
                     width = NULL,
                     icon("chart-bar", "fa-10x")
                    )))),
            column(2,
                   tags$div(class="box-link",
                   tags$a(href = "#shiny-tab-live", "data-toggle"="tab", "data-value"="live",
                   box(
                     title = "LIVE",
                     width = NULL,
                     icon("home", "fa-10x")
                   )))),
            column(2,
                   tags$div(class="box-link",
                   tags$a(href = "#shiny-tab-work", "data-toggle"="tab", "data-value"="work",
                   box(
                     title = "WORK",
                     width = NULL,
                     icon("briefcase", "fa-10x")
                   )))),
            column(2,
                   tags$div(class="box-link",
                   tags$a(href = "#shiny-tab-play", "data-toggle"="tab", "data-value"="play",
                   box(
                     title = "PLAY",
                     width = NULL,
                     icon("tree", "fa-10x")
                   )))),

            column(2,
                   tags$div(class="box-link",
                   tags$a(href = "#shiny-tab-learn", "data-toggle"="tab", "data-value"="learn",
                   box(
                     title = "LEARN",
                     width = NULL,
                     icon("graduation-cap", "fa-10x")
                   )))),
            column(2,
                   tags$div(class="box-link",
                   tags$a(href = "#shiny-tab-act", "data-toggle"="tab", "data-value"="act",
                   box(
                     title = "ACT",
                     width = NULL,
                     icon("handshake", "fa-10x")
                   ))))

            ) #End of the row
        ) #End of overview-icons class
      ) #End of the overview-tab class
    ), #--> End of Tab items

    # CIVIC Tab ----

    tabItem(
      tabName = "civic",
      tags$div(class = "civic-tab",
               fluidRow(column(
                 12,
                 box(
                   width = NULL,
                   img(src = "/images/civic.png", class = "bannerImg")
                 )
               )),
      fluidRow(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
      ),
      br(),

      fluidRow(column (2,
                       img(src = "pop_age.png", class = "popAge")
                       # fluidRow(
                       #   box(
                       #     width = NULL,
                       #     valueBoxOutput("total_population", width = NULL)
                       #   )
                       # ),
                       # fluidRow(
                       #   box(
                       #     width = NULL,
                       #     valueBoxOutput("median_age", width = NULL)
                       #   )
                       # )
                       )
                        ,
               column(
                 5,
                 box(width = NULL, title = "Age",
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
          box( class = "boxText",
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
               # <!-- Search form -->
               #   <form class="form-inline md-form form-sm mt-0">
               #   <i class="fas fa-search" aria-hidden="true"></i>
               #   <input class="form-control form-control-sm ml-3 w-75" type="text" placeholder="Search" aria-label="Search">
               #   </form>

      fluidRow(column(
                 12,
                 box(
                   width = NULL,
                   img(src = "/images/live.png", class = "bannerImg")
                 )
               )),
      fluidRow(
        column(
          12,
          box(class = "boxText",
            width = NULL,
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
          4,
          box(
            width = NULL,
            title = "",
            br(),
            br(),
            img(src = "life_expectancy.png", class = "leInfo")

          )
        ),

        column(
          8,
          box(
            width = NULL,
            title= "BIRTHS IN GUILFORD COUNTY",
            plotlyOutput("birth2")
          )

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

        column(width = 2, offset = 2,  valueBoxOutput("le_males", width = NULL)),
        column(width = 2, valueBoxOutput("le_fem", width = NULL)),
        column(width = 2, valueBoxOutput("le_white", width = NULL)),
        column(width = 2, valueBoxOutput("le_afram", width = NULL))


      ),
      fluidRow(
        column(12,
               box(class = "boxText", width = NULL,
                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Eget arcu dictum varius duis at consectetur lorem donec massa. Ut consequat semper viverra nam libero justo laoreet sit amet. Egestas congue quisque egestas diam in arcu. Suspendisse potenti nullam ac tortor vitae purus. At ultrices mi tempus imperdiet nulla malesuada pellentesque."
               ))
      ),

      fluidRow(column(
        10,
        offset = 1,
        align = "center",
        box(width = NULL,
            plotlyOutput("births"))
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
        column(12,
               box(class= "boxText", width = NULL,
                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Lectus urna duis convallis convallis tellus id interdum. Ligula ullamcorper malesuada proin libero nunc consequat interdum varius sit."

               ))
      ),

      fluidRow(
        column(
          3,
          box(
            width = NULL,
            title = "Head of household by race",
            billboarderOutput("hh_race")
          )

        ),
        column(
          8,
          box(
            width = NULL,
            title = "Percentage of Vacant Houses",
            leafletOutput("vacant_houses_map")

          )
          )


      ),

      fluidRow(
        column(12,
               align = "center",
               h1("Food Deserts Map"),
               leafletOutput("food_stores_map")
               )
      ),
      fluidRow(
        column(12,
               align = "center",
               h1("Deaths Map"),
               leafletOutput("death_map"))
      )
    )),

    # WORK Tab ----


    tabItem(
      tabName = "work",
      tags$div(class = "work-tab",
      fluidRow(column(
                 12,
                 box(
                   width = NULL,
                   img(src = "/images/work.png", class = "bannerImg")
                 )
               )),

      fluidRow(
        column(
          12,
          box(class = "boxText",
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
          box(class = "boxText",
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
               box(class = "boxText",
                 width = NULL,
                 "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."

               ))
      ),
      fluidRow(
        column(6,
               box(width = NULL,
                 title = "Means of Transportation by Race",
                 billboarderOutput("transportation_race")
               )),
        column(6,
               box(
                 width = NULL,
                 title = "Means of Transportation by Ethnicity",
                 billboarderOutput("transportation_ethnicity")
               )

        )
      )
    )),

    # PLAY Tab ----

    tabItem(
      tabName = "play",
      tags$div(class = "play-tab",
      fluidRow(column(12,
                               align = "center",
                               box(
                                 width = NULL,
                                 img(src = "play.png", class = "bannerImg")

                               ))),
      fluidRow(
        column(12,
               box(class = "boxText",
                 width = NULL,
                 "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."

               ))
         ),
      fluidRow(
        column(10,
               offset=1,
               box(width = NULL,
                 title = "Average weather over the last 48 months",
                 plotlyOutput("weather")
               ))
      ),
      fluidRow(
        column(4,
               box(
                 width = NULL,
                 br(),
                 br(),
                 br(),
                 HTML('<iframe id = "myFrame" src="https://www.youtube.com/embed/ScMzIvxBSi4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
               )),

      column(2,
             box(
               width = NULL,
               img(src = "tourism.png", class = "tourismInfo")
             )),
      column(6,
             br(),
             br(),
             br(),
             box(class = "boxText",
               width = NULL,
               "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. "

             ))
      ),

      fluidRow(),

      fluidRow(
        column(12,
               box(
                 width = NULL,
                 title = "Parks Map",
                 leafletOutput("parks_map")
               ))
      )
    )),

    #LEARN Tab ----

    tabItem(
      tabName = "learn",
      tags$div(class = "learn-tab",
               fluidRow(column(12,
                               align = "center",
                               box(
                                 width = NULL,
                                 img(src = "/Images/learn.png", class = "bannerImg")

                               ))),
               br(),
               br(),

      fluidRow(
        column(12,
               box(class= "boxText",
                 width = NULL,
                 "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. "
                  ))),
      br(),
      br(),
      br(),
      fluidRow(
        column(12,
               box(
                 width = NULL,
                 title = "Schools Map",
                 leafletOutput("schools_map")
               )
      )),

      br(),
      br(),
      br(),
      fluidRow(
        column(6,
               align = "center",
               h2("IMAGE")
        ),
        column(6,
               align = "center",
               h2("IMAGE")
        )),
      br(),
      br(),
      fluidRow(
        column(12,
               box(class = "boxText",
                   width = NULL,
                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. "

               ))),
      br(),
      fluidRow(column(
                 6,
                 box(width = NULL, title = "Percent of College and University Students by Institution",
                     billboarderOutput("students"))
               ),
               column(
                 6,
                 box(width = NULL,
                     title = "Completion Rates for Guilford County's Colleges and Universities",
                     billboarderOutput("completion"))
               )),
      br(),
      br(),
      br(),
      fluidRow(
        column(12,
               box(class = "boxText",
                 width = NULL,
                 "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. "

               ))),
      br(),
      fluidRow(column(
        6,
        box(width = NULL,
            title = "Debt to Income Ratio for Guilford County's Colleges and Universities",
            billboarderOutput("debt"))

      ),
      column(
        6,
        box(width = NULL,
            title = "Retention Rates for Guilford County's Colleges and Universities",
            billboarderOutput("retention"))
      ))

    )),

    # ACT Tab ----

    tabItem(
      tabName = "act",
      tags$div(class = "act-tab",
               fluidRow(column(12,
                               align = "center",
                               box(
                                 width = NULL,
                                 img(src = "/Images/act.png", class = "bannerImg")

                               ))),
      fluidRow(
        column(12,
               box(class = "boxText",
                   width = NULL,
                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. "

               ))),
      fluidRow(

        column(6,
          box(
            width = NULL,
            title = "Race and Party Affliation of Registered Voters",
            billboarderOutput("voters_rp")

          )
        ),
        column(6,
               box(
                 width = NULL,
                 title = "Gender and Party Affiliation of Registered Voters",
                 billboarderOutput("voters_gp")
               ))
      ),
      fluidRow(
        column(4,
               offset = 1,
               box(
                 width = NULL,
                 "Video"
               )),
        column(6,
               box(
                 width = NULL,
                 htmlOutput("act_projects")
               ))

      )
    )

      ))
      )



# Define the UI ---------------------------------------------------------

ui <- dashboardPage(
  title = "Guilford CIP",
  skin = "blue",
  dashboardHeader(title = "Guilford Community Indicators", tags$li(img(src='/images/guilford-logo.png'), class="dropdown")),
  sidebar,
  body
)



# Define the server -----------------------------------------------------

server <- function(input, output) {
  # CIVIC Tab ----

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



  # LIVE Tab ----



  output$le_males <- renderValueBox({
    value <- life_expectancy%>%
      filter(key == "males") %>%
      mutate(diff = (`Guilford County`- `State of North Carolina`)*12) %>%
      mutate(diff = round(diff,0)) %>%
      pull (diff)

    valueBox(paste0(value, " months"), "Men", icon = icon("arrow-up"), color= "orange")

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

  output$birth2 <- renderPlotly({

    plot_ly(data = births, x =~yob, y = ~Females, type = 'scatter', mode = 'lines+markers',
            line= list(color= '#113535', width =2.5),
            marker = list(color= '#113535', width =3),
            name = 'Females') %>%
      add_trace(y=~Males, line = list(color='#CB942B'),
                marker = list(color= '#CB942B'),
                name = 'Males') %>%
      layout(yaxis = list(title = "", separatethousands = TRUE),
             xaxis = list(title = "", tickangle = 45, tickfont = list(size = 10)),
             legend = list(orientation = 'h', y = -0.2, x = 0.2))
  })


  output$births <- renderPlotly({

    plot_ly(data = births, x =~yob, y = ~Females, type = 'scatter', mode = 'lines+markers',
            line= list(color= '#89ada7', width =2.5),
            marker = list(color= '#89ada7', width =3),
            name = 'Females') %>%
      add_trace(y=~Males, line = list(color='#AC492E'),
                marker = list(color= '#AC492E'),
                name = 'Males') %>%
      layout(yaxis = list(title = "", separatethousands = TRUE),
             xaxis = list(title = "", tickangle = 45, tickfont = list(size = 10)),
             legend = list(orientation = 'h', y = -0.2, x = 0.2))
  })


  output$hh_race <- renderBillboarder({

    billboarder() %>%
      bb_donutchart(data = hh_race) %>%
      bb_color(palette = c("#E54B21", "#113535", "#617030", "#CB942B", "#89ada7", "#AC492E", "#071A1E", "#026637"))


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

  output$food_stores_map <- renderLeaflet({
    leaflet(data = food_stores) %>%
      addTiles() %>%
      addCircleMarkers(lat = ~lat, lng = ~lon, popup = ~name,
                       stroke = TRUE, fillOpacity = 0.075)
  })

  output$death_map <- renderLeaflet({
    leaflet(data = death) %>%
      addTiles() %>%
      addMarkers(lat = ~location.y, lng = ~location.x,
                 clusterOptions = markerClusterOptions())
  })
  # LEARN tab ----

  output$students <- renderBillboarder({

    plot <- guilford %>%
      select(Institution_Name, total_students_entering_2016)


    billboarder() %>%
      bb_donutchart(data = plot) %>%
      bb_color(palette = c("#E54B21", "#113535", "#617030", "#CB942B", "#89ada7", "#AC492E", "#071A1E", "#026637"))


  })

  output$completion <- renderBillboarder({

    plot <- guilford %>%
      select(Institution_Name, total_complete_avg) %>%
      mutate(total_complete_avg = total_complete_avg*100) %>%
      arrange(desc(total_complete_avg))

    billboarder() %>%
      bb_barchart(data = plot, rotated = TRUE) %>%
      #bb_axis(x = list(tick = list(fit = T)), y = list(tick = list(fit = T))) %>%
      #bb_add_style(text = "font-size: 75%"  ) %>%
      bb_legend(show = FALSE) %>%
      bb_y_axis(tick = list(format = suffix("%"))) %>%
      bb_color(palette = c("#88853B")) %>%
      bb_x_axis(tick = list(width = 250))



  })

  output$retention <- renderBillboarder({

    plot <- guilford %>%
      select(Institution_Name, full_time_retention_rate_mean) %>%
      mutate(full_time_retention_rate_mean = full_time_retention_rate_mean*100) %>%
      arrange(desc(full_time_retention_rate_mean))

    billboarder() %>%
      bb_lollipop(data = plot, x = "full_time_retention_rate_mean", y = "Institution_Name", rotated = F) %>%
      #bb_axis(x = list(tick = list(fit = T)), y = list(tick = list(fit = T))) %>%
      #bb_add_style(text = "font-size: 75%"     ) %>%
      bb_legend(show = FALSE) %>%
      bb_y_axis(tick = list(format = suffix("%"))) %>%
      bb_color(palette = c("#113535")) %>%
      bb_axis(x =list(height = 60))


  })

  output$debt <- renderBillboarder({

    plot <- guilford %>%
      select(Institution_Name, debt_to_earnings_ratio_best) %>%
      arrange(desc(debt_to_earnings_ratio_best))

    billboarder() %>%
      bb_barchart(data = plot, x = "debt_to_earnings_ratio_best", y = "Institution_Name", rotated = T) %>%
      #bb_axis(x = list(tick = list(fit = T)), y = list(tick = list(fit = T))) %>%
      #bb_add_style(text = "font-size: 75%") %>%
      bb_legend(show = FALSE) %>%
      bb_y_axis(tick = list(format = suffix("%"))) %>%
      bb_color(palette = c("#89ada7"))   %>%
      bb_x_axis(tick = list(width = 250))

  })

  output$schools_map <- renderLeaflet({
    leaflet(data = schools) %>%
      addTiles() %>%
      addMarkers(lat = ~lat, lng = ~lon, popup = ~name,
                 clusterOptions = markerClusterOptions())
  })


  # WORK Tab ----

  output$emp_race <- renderBillboarder({
    billboarder() %>%
      bb_barchart(data = emp_race) %>%
      bb_bar(padding = 2) %>%
      bb_color(palette = c("#617030", "#CB942B", "#89ada7", "#AC492E", "#071A1E", "#026637", "#113535")) %>%
      bb_y_axis(tick = list(format = suffix("%")))

  })

  output$med_inc_race <- renderBillboarder({
    med_income_race <- med_income %>%
      filter(race!="White Alone, Not Hispanic or Latino") %>%
      filter(race!="Hispanic or Latino") %>%
      filter(!is.na(estimate)) %>%
      select(race, estimate) %>%
      arrange(desc(estimate))

    billboarder() %>%
      bb_lollipop(data = med_income_race, point_color = "#CB942B", line_color = "#CB942B") %>%
      bb_axis(x =list(height = 40))%>%
      bb_y_axis(tick = list(format = htmlwidgets::JS("d3.format(',')")
      ))

      #bb_barchart(data = med_income_race)
  })

  output$med_inc_ethn <- renderBillboarder({

    med_income_ethn <- med_income %>%
      filter(race=="White Alone, Not Hispanic or Latino"| race =="Hispanic or Latino" ) %>%
      select(race, estimate)

    billboarder() %>%
      bb_lollipop(data = med_income_ethn, point_color = "#026637", line_color = "#026637") %>%
      bb_axis(x =list(height = 20)) %>%
      bb_y_axis(tick = list(format = htmlwidgets::JS("d3.format(',')")
      ))
      #bb_barchart(data = med_income_ethn)
  })


  output$transportation_race <- renderBillboarder({

    transp_race <- transp %>%
      filter(level!=1) %>%
      filter(race == "White alone"|race == "Black or African American Alone"|race == "Two or More Races") %>%
      mutate(label = str_remove(label, "Estimate!!Total!!")) %>%
      mutate(perc = round(estimate/Total*100,0)) %>%
      select(race, label, perc) %>%
      spread(race, perc)

    billboarder() %>%
      bb_barchart(data = transp_race, rotated = T) %>%
      bb_bar(padding = 2) %>%
      bb_color(palette = c("#617030", "#CB942B", "#89ada7", "#AC492E", "#071A1E", "#026637", "#113535"))%>%
      bb_y_axis(tick = list(format = suffix("%"))) %>%
      bb_x_axis(tick = list(width = 250))

  })


  output$transportation_ethnicity <- renderBillboarder({

    transp_ethn <- transp %>%
      filter(level!=1) %>%
      filter(race == "White Alone, Not Hispanic or Latino"|race == "Hispanic or Latino") %>%
      mutate(label = str_remove(label, "Estimate!!Total!!")) %>%
      mutate(perc = round(estimate/Total*100,0)) %>%
      select(race, label, perc) %>%
      filter(perc!=0) %>%
      spread(race, perc)

    billboarder() %>%
      bb_barchart(data = transp_ethn, rotated = T) %>%
      bb_bar(padding = 2) %>%
      bb_color(palette = c("#AC492E", "#113535", "#CB942B")) %>%
      bb_x_axis(tick = list(width = 250)) %>%
      bb_y_axis(tick = list(format = suffix("%")))


  })


  # PLAY Tab ----

  output$weather <- renderPlotly({

    plot_ly(data = weather) %>%
      add_trace(x =~month,y=~precipitation, type = 'bar',
                marker = list(color= 'rgb(223,226,213)'),
                name = 'PPtn') %>%
      add_trace(x =~month, y = ~daily_avg, type = 'scatter', mode = 'lines',
                line= list(color= 'rgb(97,112,48)', width =2.5),
                name = 'Average Temperature',
                yaxis = "y2") %>%
      layout(xaxis = list(title = ""),
             yaxis = list(side = 'right', title = "Precipitation (in inches)", showgrid = F),
             yaxis2 = list(side = 'left', overlaying = "y", title = "Temp (in F)", showgrid = F),
             legend = list(orientation = 'h', y = -0.2, x = 0.2))
  })


  output$parks_map <- renderLeaflet({
    leaflet(data = parks) %>%
      addTiles() %>%
      addMarkers(lat = ~lat, lng = ~lon, popup = ~name,
                 clusterOptions = markerClusterOptions())
  })


  # ACT Tab ----

  output$act_projects <- renderUI({

  value <- projects %>%
    select(act)

    HTML(paste(value$act, sep = '</br>'))

  })

  output$voters_gp <- renderBillboarder({
    voters_gp <- active_voters %>%
      group_by(gender_code, party_cd) %>%
      summarise(count = n()) %>%
      mutate(denom = sum(count)) %>%
      mutate(perc = round(count/denom*100, 0) ) %>%
      select(gender_code, party_cd, perc) %>%
      filter(perc!=0) %>%
      filter(!is.na(perc), !is.na(gender_code)) %>%
      spread(party_cd, perc)

    billboarder() %>%
      bb_barchart(data = voters_gp) %>%
      bb_bar(padding = 2) %>%
      bb_color(palette = c("#071a1e", "#026637", "#88853b", "#3a7993")) %>%
      bb_y_axis(tick = list(format = suffix("%")))


  })


  output$voters_rp <- renderBillboarder({
    voters_rp <- active_voters %>%
      group_by(party_cd, race_code) %>%
      summarise(count = n()) %>%
      mutate(denom = sum(count)) %>%
      mutate(perc = round(count/denom*100, 0) ) %>%
      select(party_cd, race_code, perc) %>%
      filter(perc!=0) %>%
      filter(!is.na(perc)) %>%
      spread(race_code, perc)


    billboarder() %>%
      bb_barchart(data = voters_rp, rotated = F) %>%
      bb_bar(padding = 2) %>%
      bb_color(palette = c("#617030", "#CB942B", "#89ada7", "#AC492E", "#071A1E", "#026637", "#113535"))%>%
      bb_y_axis(tick = list(format = suffix("%")))  %>%
      bb_axis(x =list(height = 50))

  })




}


# Run the app -------------------------------------------------------------

shinyApp(ui, server)
