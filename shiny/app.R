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
projects <- read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/projects.csv")
death <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_addresses_geocoded.rds")
schools <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/schools.rds")
food_stores <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/food_stores.rds")
parks <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/parks.rds")
projects_txt <- file("./data/projects_act.txt")



# Define individual UI elements -------------------------------------------

# Define the sidebar ----

# Define the body ----

body <- mainPanel(
    tabsetPanel(
        type = "tabs",
        
        # Overview Tabs ----
        
        tabPanel(title = "Overview",
                 tags$div(
                     class = "overview-tab",
                     br(),
                     
                     fluidRow(column(
                         12,
                         img(src = "./Images/overview.png", class = "bannerImg")
                         
                     )),
                     br(),
                     
                     fluidRow(column(
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
                     )
        )
        ),
        tabPanel(title = "Civic"),
        tabPanel(title = "Live"),
        tabPanel(title = "Work"),
        tabPanel(title = "Play"),
        tabPanel(title = "Learn"),
        tabPanel(title = "Act")
    )
)



# Define the UI -----------------------------------------------------------

ui <- fluidPage(theme = "dashboard.css",
                titlePanel(title = div(img(src = './Images/guilford-logo.png', class = "logoImg"))),
    body
)


# Define the server -------------------------------------------------------
server <- function(input, output) {}



# Run the app -------------------------------------------------------------
shinyApp(ui, server)






