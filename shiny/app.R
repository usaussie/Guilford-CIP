library(shiny)
library(shinydashboard)
library(shinythemes)
library(billboarder)
library(tidyverse)
library(leaflet)
library(plotly)
library(sf)
library(siverse)



# Load data ---------------------------------------------------------------


#load from github

load("./data/ages1.rda")
load("./data/race_all.rda")
load("./data/ethnicity_all.rda")
load("./data/sex_all.rda")
load("./data/emp_race.rda")
load("./data/age.rda")
load("./data/med_income.rda")
load("./data/vacant_housing.rda")
load("./data/geo_places.rda")
load("./data/hh_race.rda")
load("./data/life_expectancy.rda")
load("./data/births.rda")
load("./data/weather.rda")
load("./data/ipeds.rda")
load("./data/transportation.rda")
load("./data/voters.rda")
load("./data/deaths.rda")
load("./data/tourism.rda")
load("./data/tenure_race.rda")
load("./data/imr.rda")
load("./data/diabetes.rda")
load("./data/food_insecurity.rda")
load("./data/snap.rda")

schools <- read_rds("./data/schools.rds")
load("./data/parks_1.rda")
food_stores <- read_rds("./data/food_stores.rds")
exploremap <- read_rds("./data/exploremap.rds")
explore_acsdata <- read_rds("./data/explore_acsdata.rds")
gcs <- read_rds("./data/gcs.rds")


# Editable text files
live_resources <- read_csv("./edit/live_resources.txt")
live_projects <- read_csv("./edit/live_projects.txt")
live_missing <- read_csv("./edit/live_missing.txt")
work_resources <- read_csv("./edit/work_resources.txt")
work_projects <- read_csv("./edit/work_projects.txt")
work_missing <- read_csv("./edit/work_missing.txt")
play_resources <- read_csv("./edit/play_resources.txt")
play_projects <- read_csv("./edit/play_projects.txt")
play_missing <- read_csv("./edit/play_missing.txt")
learn_resources <- read_csv("./edit/learn_resources.txt")
learn_projects <- read_csv("./edit/learn_projects.txt")
learn_missing <- read_csv("./edit/learn_missing.txt")
engage_resources <- read_csv("./edit/engage_resources.txt")
engage_projects <- read_csv("./edit/engage_projects.txt")
engage_missing <- read_csv("./edit/engage_missing.txt")
civic_resources <- read_csv("./edit/civic_resources.txt")
civic_projects <- read_csv("./edit/civic_projects.txt")
civic_missing <- read_csv("./edit/civic_missing.txt")

#load from drive

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
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/deaths.rda")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/tourism.rda")
# projects <-read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/projects.csv")
# death <-read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_addresses_geocoded.rds")
# schools <-read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/schools.rds")
# food_stores <-read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/food_stores.rds")
# load("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/parks_1.rda")
# exploremap <- read_rds("~/Google Drive/SI/DataScience/data/Guilford County CIP/dashboard/exploremap.rds")



# Define individual UI elements -------------------------------------------

# Define the sidebar ----

# Define the body ----

body <- mainPanel(width = 12,
  fluidRow(), 
  
  fluidRow(
    column(10, offset = 1, 
           "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien.")
  ), 
  br(),

  fluidRow(
    img(src = './Images/line.png',class = "lineImg")
  ),
  br(),
  tabsetPanel(
      
        type = "tabs", 
        
        # Demographics Tab ----
        
        tabPanel(
        
            title = "DEMOGRAPHICS", icon = icon("binoculars"), 
            tags$div(class = "demographics-tab",
                     
                     br(),
                     
                     fluidRow(
                       column(
                         12, 
                         img(src = "./Images/demographics.png", class = "sec-bannerImg")
                       )
                     ),
                     br(),
                     
                     fluidRow(
                       column(
                         12,
                         "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                         
                       )
                     ),
                     br(),
                     fluidRow(
                       
                       column(
                         2,
                         img(src = "./Images/pop_age.png", class = "popAge"),
                         h6("Data Source: U.S. Census Bureau (2013-2017). American Community Survey 5-year estimates. Tables B01001 Sex by Age, B01002 Median Age by Sex")
                       ),
                       column(
                         2,
                         radioButtons("location_rb_d", label = h3("Select Location"),choices = c("Guilford County", "Greensboro city", "High Point city"))
                       ),
                       column(
                         4, 
                         h3("Age Distribution", align ="center"),
                         billboarderOutput("age"),
                         h6("Data Source: U.S. Census Bureau (2013-2017). American Community Survey 5-year estimates. Table B01001 Sex by Age", align = "center")
                         
                       ),
                       column(
                         4, 
                         h3("Males to Females in Guilford County", align = "center"),
                         billboarderOutput("sex"), 
                         h6("Data Source: U.S. Census Bureau (2013-2017). American Community Survey 5-year estimates. Table B01001 Sex by Age", align = "center")
                         
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
                       column(2,
                              radioButtons("location_rb_d1", label = h3("Select Location"),choices = c("Guilford County", "Greensboro city", "High Point city"))
                       ),
                       column(
                         5,
                         h3("Race", align = "center"),
                         billboarderOutput("race"), 
                         h6("Data Source: U.S. Census Bureau (2013-2017). American Community Survey 5-year estimates. Table B01001: Sex by Age. Tables B01001A, B01001B, B01001C, B01001D, B01001E, B01001F, B01001G: Sex by Age (Racial Iterations). ", align = "center")
                       ), 
                       column(
                         5, 
                         h3("Ethnicity", align = "center"),
                         billboarderOutput("ethnicity"), 
                         h6("Data Source: U.S. Census Bureau (2013-2017). American Community Survey 5-year estimates. Table B03003: Hispanic or Latino Origin.", align = "center")
                       )
                       
                       
                     ),
                     fluidRow(
                       column(
                         12,
                         
                         "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                       )),
                     br()
                     
                     
                     
                    
                     
                     )
        ),
        
       
        
        # Live Tab -----
        tabPanel(title = "LIVE", icon = icon("home"),
                 tags$div(class = "live-tab",
                          br(),
                          fluidRow(column(12,
                                          img(src = "./Images/live.png", class = "sec-bannerImg"))),
                          br(),
                          
                          fluidRow(
                            column(12,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                            )),
                          br(),
                          fluidRow(
                            column(
                              2,
                              offset = 3,
                              wellPanel(
                                align = "center",
                                HTML("<a href='#people'><h4> Jump to People </h4> </a>")
                              )
                            ),
                            column(
                              2,
                              wellPanel(
                                align = "center",
                                HTML("<a href='#housing'><h4> Jump to Housing </h4> </a>")
                              )
                            ),
                            column(
                              2,
                              wellPanel(
                                align = "center",
                                HTML("<a href='#health'><h4> Jump to Health </h4> </a>")
                              )
                            )
                          ),
                          tags$div(fluidRow(
                            class = "subtitle",
                            column(
                              12,
                              align = "center",
                              
                              div(h1("PEOPLE"),id = "people")
                              
                            )
                          )),
                          
                          
                          fluidRow(
                            column(
                              4,
                              offset  = 1,
                              
                              img(src = "./Images/life_expectancy.png", class = "leInfo"), 
                              h6("Data Source: North Carolina Center for Health Statistics (2017)", align = "center")
                              
                            ),
                            
                            column(
                              7,
                              align = "center",
                              img(src = "./Images/live01.jpg", class = "live01")
                              
                            )
                          ), 
                          br(),
                          
                          fluidRow(
                            column(
                              4,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Vitae ultricies leo integer malesuada nunc. Bibendum enim facilisis gravida neque convallis. Ac felis donec et odio pellentesque diam volutpat commodo sed. Rhoncus est pellentesque eliullamcorper dignissim cras tincidunt lobortis feugiat."
                            ),
                            column(
                              8,
                              align= "center",
                              h3("Births Over Time", align = "center"),
                              
                              plotlyOutput("birth2"), 
                              h6("Data Source: Jason's Data", align = "center")
                              
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
                              8,
                              offset = 2,
                              h3("Unnatural Deaths by Race and Sex", align = "center"),
                              
                              billboarderOutput("deaths"),
                              h6("Data Source: Jason's Data", align = "center")
                              
                              
                            )
                            
                            
                          ),
                         
                          

                          tags$div(fluidRow(
                            class = "subtitle",
                            column(
                              12,
                              align = "center",

                                div(h1("HOUSING"),id = "housing")

                            )
                          )),

                          fluidRow(
                            column(12,

                                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Eget arcu dictum varius duis at consectetur lorem donec massa. Ut consequat semper viverra nam libero justo laoreet sit amet. Egestas congue quisque egestas diam in arcu. Suspendisse potenti nullam ac tortor vitae purus. At ultrices mi tempus imperdiet nulla malesuada pellentesque."
                                   )
                          ),

                          fluidRow(
                            column(
                              6,
                              img(src = "./Images/live02.jpg", class = "live02")
                              ),
                            column(
                              
                              6, 
                              h3("Food Insecurity", align ="center"),
                              plotlyOutput("food_insecurity"),
                              h6("Source: Piedmont Health Counts", align = "center")
                              
                              
                              
                            )),
                          br(),
                          fluidRow(
                            

                            column(8,
                                   offset =2,
                                   h3("Access to Food Stores", align = "center"),

                                       leafletOutput("food_stores_map"),
                                   h6("Data Source: Google Maps API Pulls (2019)", align = "center")


                            )
                          ),
                         br(),
                         br(),
                         fluidRow(
                           "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. "
                           
                         ),
                         br(),
                         
                         fluidRow(
                           column(2,
                                  radioButtons("location_rb", label = h3("Select Location"),choices = c("Guilford County", "Greensboro city", "High Point city"))),
                           column(
                             5,
                             h3("Race of Householder", align = "center"),
                             billboarderOutput("hh_race"),
                             h6("Data Source: U.S. Census Bureau (2017). American Community Survey 1-year estimates. Table B25006 Race of Householder", align  = "center")
                           ), 
                           column(
                             5, 
                             h3("Owned vs Rented Homes", align = "center"),
                             billboarderOutput("tenure_race"),
                             h6("Data Source: U.S. Census Bureau (2017). American Community Survey 1-year estimates. Table B25003 Tenure. Tables B25003A, B25003B, B25003C, B25003D, B25003E, B25003F, B25003G Tenure (Racial Iterations).", align  = "center")
                           )
                         ),
                         
                         

                          fluidRow(

                            column(
                              8,
                              offset = 2,
                              h3("Percentage of Vacant Houses", align = "center"),

                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien.",
                              fluidRow(br()),    
                              leafletOutput("vacant_houses_map"),
                              h6("Data Source: U.S. Census Bureau (2017).American Community Survey 1-year estimates. Table B25002 Occupancy Status", align = "center")


                            )


                          ),
                         
                         div(
                           
                           fluidRow(class= "subtitle", 
                             column(
                               12, 
                               align = "center", 
                               div(h1("HEALTH"), id = "health")
                             )
                           )
                         ),
                         
                         br(),
                         
                         fluidRow(
                           "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. "
                         
                         ),
                 fluidRow(
                   
                    column(2,
                           radioButtons("location_rb3", label = h3("Select Location"),
                                        choices = c("Guilford County", "Greensboro city", "High Point city"))),
                    column(
                      4,
                      h3("Receipt of Food Stamps/SNAP ", align = "center"),
                      h1(htmlOutput("snap")),
                      h6("Data Source: U.S. Census Bureau (2017).American Community Survey 1-year estimates. Table B22003 Receipt of Food Stamps/SNAP", align = "center")
                    ),
                    
            
                   column(
                     4,
                          h3("Infant Mortality Rate", align = "center"),
                          billboarderOutput("imr"),
                          h6("Source: Piedmont Health Counts", align = "center")
                          ),
                   column(
                     2,
                     h3("Diabetes", align = "center"),
                     h1(htmlOutput("diabetes")),
                     h6("Source: Piedmont Health Counts", align = "center")
                   )
                 ),
                         
                         fluidRow(
                           column(4,
                                  offset = 1,
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. "),
                           column(
                             6, 
                             a(img(src = "./Images/live03.png", class = "live03"), href = "http://www.piedmonthealthcounts.org/", target="_blank")
                           )
                         ),
                         br(),
                         fluidRow(
                            column(4,
                                   align = "center",
                                   wellPanel(
                                   h3("Community Projects"),
                                   htmlOutput("live_projects"))
                                   ),
                            column(4,
                                   align = "center",
                                   wellPanel(
                                   h3("Resources"),
                                   htmlOutput("live_resources"))
                                   ),
                            column(4,
                                   align = "center",
                                   wellPanel(
                                   h3("What's Missing?"), 
                                   htmlOutput("live_missing"))
                            )
                          ),
                         br()
                 )),
        # Work Tab ----
        tabPanel(title = "WORK", icon = icon("briefcase"),
                 
                 tags$div(class = "work-tab",
                          br(),
                          fluidRow(column(
                            12,
                            img(src = "./Images/work.png", class = "sec-bannerImg")
                            
                          )),
                          br(),
                          
                          fluidRow(
                            column(
                              12,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                              )
                          ),
                          
                          fluidRow(
                            column(10,
                                   offset = 1,
                                   align = "center",
                                   h3("Employment  Percentage (Civilian Labor Force) by Race and Sex", align = "center"),
                                   billboarderOutput("emp_race"),
                                   h6("Data Source: U.S. Census Bureau (2013-2017). American Community Survey 5-year estimates. Table B23002: Sex by Age by Employment Status. Tables B23002A, B23002B, B23002C, B23002D, B23002E, B23002F, B23002G: Sex by Age by Employment Status (Racial Iterations).", align = "center")
                            )
                          ),
                          
                          fluidRow(
                            column(
                              12,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                              )
                          ),
                          br(),
                          
                          fluidRow(
                            column(
                              10, offset = 1,
                              img(src = "./Images/work01.jpg", class ="work01")
                            )
                          ),
                          br(),
                          
                          fluidRow(
                            column(6,
                                   align  ="center",
                                   h3("Median Household Income by Race", align = "center"),
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. ",
                                  fluidRow(br()),
                                   billboarderOutput("med_inc_race"), 
                                   h6("Data Source: U.S. Census Bureau (2013-2017). American Community Survey 5-year estimates. Table B19013: Median Household Income. Tables B19013A, B19013B, B19013C, B19013D, B19013E, B19013F, B19013G: Median Household Income (Racial Iterations).", align = "center")
                                   ),
                            column(5,
                                   h3("Median Household Income by Ethnicity", align = "center"),
                                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id.    ",
                                   fluidRow(br()),  
                                    billboarderOutput("med_inc_ethn"),
                                   h6("Data Source: U.S. Census Bureau (2013-2017). American Community Survey 5-year estimates. Table B19013: Median Household Income. Tables B19013H, B19013BI: Median Household Income (Ethnic Iterations).", align = "center")
                                   )
                          ),
                          
                          br(),
                          br(),
                          
                          fluidRow(
                            column(10, offset = 1,
                                   img(src = "./Images/work02.jpg", class = "work02")
                                   )
                          ),
                          
                          br(),
                          
                          fluidRow(
                            column(12,
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                                       
                                   )
                          ),
                          fluidRow(
                            column(6,
                                   h3("Means of Transportation by Race", align = "center"),
                                       billboarderOutput("transportation_race"),
                                   h6("Data Source: U.S. Census Bureau (2017). American Community Survey 1-year estimates. Table B08105: Means of Transportation to Work. Tables B08105A, B08105B, B08105C, B08105D, B08105E, B08105F, B08105G: Means of Transportation to Work (Racial Iterations).", align = "center")
                                   ),
                            column(6,
                                   h3("Means of Transportation by Ethnicity", align = "center"),
                                     billboarderOutput("transportation_ethnicity"), 
                                   h6("Data Source: U.S. Census Bureau (2017). American Community Survey 1-year estimates. Table B08105: Means of Transportation to Work. Tables B08105H, B08105I: Means of Transportation to Work (Ethnic Iterations).", align = "center")
                                   
                                   
                            )
                          ),
                          br(),
                          fluidRow(column(4,
                                          align = "center",
                                          wellPanel(
                                            h3("Community Projects"),
                                            htmlOutput("work_projects"))
                          ),
                          column(4,
                                 align = "center",
                                 wellPanel(
                                   h3("Resources"),
                                   htmlOutput("work_resources"))
                          ),
                          column(4,
                                 align = "center",
                                 wellPanel(
                                   h3("What's Missing?"), 
                                   htmlOutput("work_missing"))
                          )),
                          br()
                 )),
        # Play tab ----
        tabPanel(title = "PLAY", icon = icon("child"),
                 tags$div(class = "play-tab",
                          br(),
                          fluidRow(column(12,
                                          align = "center",
                                          img(src = "./Images/play.png", class = "sec-bannerImg")
                                          )),
                          br(),
                          fluidRow(
                            column(
                              12, 
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                            )
                          ),
                          br(),
                          fluidRow(
                            
                            column(
                              2,
                              offset = 3,
                              wellPanel(
                                align = "center",
                                HTML("<a href='#parks'><h4> Jump to Parks </h4> </a>")
                              )
                            ),
                            column(
                              2,
                              wellPanel(
                                align = "center",
                                HTML("<a href='#arts'><h4> Jump to Arts </h4> </a>")
                              )
                            ),
                            column(
                              2,
                              wellPanel(
                                align = "center",
                                HTML("<a href='#sports'><h4> Jump to Sports </h4> </a>")
                              )
                            )
                            
                          ),
                          
                          tags$div(fluidRow(
                            class = "subtitle",
                            column(
                              12,
                              align = "center",
                              
                              div(h1("PARKS"),id = "parks")
                              
                            )
                          )),
                          br(),
                          fluidRow(
                            column(
                              12,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                            )),
                          br(),
                          fluidRow(
                            
                            column(10,
                                   offset = 1,
                                   h3("Parks Map", align = "center"),
                                   leafletOutput("parks_map"),
                                   h6("Data Source: Google Maps API Pulls (2019)", align = "center")
                            )
                            
                          ),
                          br(),
                          
                          
                          fluidRow(
                            column(10,
                                   offset=1,
                                   h3("Average Weather Over the Last 48 Months", align = "center"),
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien.",
                                  plotlyOutput("weather"), 
                                  h6("Data Source: State Climate Office of North Carolina, NC CRONOS Database", align = "center")
                                   )
                          ),
                          
                          tags$div(fluidRow(
                            class = "subtitle",
                            column(
                              12,
                              align = "center",
                              
                              div(h1("ARTS"),id = "arts")
                              
                            )
                          )),
                          br(),
                          fluidRow(
                            column(
                              12,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                            )),
                          br(),
                          fluidRow(
                            column(
                              8,
                              align = "center",
                              HTML('<iframe width="1100" height="260" src="https://www.youtube.com/embed/ScMzIvxBSi4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                              
                            ),
                            
                            column(
                              4,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                             )
                          ),
                          
                          fluidRow(),
                          
                          fluidRow(
                            column(2,
                                   img(src = "./Images/tourism.png", class = "tourismInfo")
                                   ),
                            column(4,
                                   br(),
                                   br(),
                                   br(),
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. "
                                   ),
                            column(6,
                                   h3("Visitor Spending Over Time", align = "center"),
                                     plotlyOutput("tourism_spending"), 
                                   h6("Data Source: The Economic Impact of Travel on North Carolina Counties” study prepared for Visit North Carolina by the U.S. Travel Association", align = "center")
                                   )
                          ),
                          br(),
                          fluidRow(
                            column(12,
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. "
                                   )),
                          tags$div(fluidRow(
                            class = "subtitle",
                            column(
                              12,
                              align = "center",
                              
                              div(h1("SPORTS"),id = "sports")
                              
                            )
                          )),
                          br(),
                          fluidRow(
                            column(
                              12,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                            )),
                          br(),
                          
                          fluidRow(
                            column(6,
                                   fluidRow(br(),
                                            br()),
                                   img(src = "./Images/play02.png", class = "play02")
                                   ),
                            column(
                              6,
                               h3("Strava HeatMap  of Bike/Running Lanes", align = "center"),
                               img(src = "./Images/strava.png", class ="strava")
                              )
                          ),
                          br(),
                          
                          fluidRow(
                            
                            column(4,
                                   align = "center",
                                   wellPanel(
                                     h3("Community Projects"),
                                     htmlOutput("play_projects"))
                            ),
                            column(4,
                                   align = "center",
                                   wellPanel(
                                     h3("Resources"),
                                     htmlOutput("play_resources"))
                            ),
                            column(4,
                                   align = "center",
                                   wellPanel(
                                     h3("What's Missing?"), 
                                     htmlOutput("play_missing"))
                            )
                            
                          ),
                          br()
                 )),
        # Learn Tab ----
        tabPanel(title = "LEARN", icon = icon("graduation-cap"),
                 tags$div(class = "learn-tab",
                          br(),
                          fluidRow(column(12,
                                          align = "center",
                                          img(src = "./Images/learn.png", class = "sec-bannerImg")
                                            
                                          )),
                          br(),
                          
                          fluidRow(
                            column(12,
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. "
                                   )),
                          br(),
                          br(),
                          br(),
                          fluidRow(
                            column(10,
                                   offset = 1,
                                   h3("Schools Map", align = "center"),
                                     leafletOutput("schools_map"), 
                                   h6("Data Source: GCS (placeholder) ", align = "center")
                           )),
                          
                          br(),
                          fluidRow(
                            column(
                              8, 
                              offset = 2,
                              h3("School Performance Metrics", align = "center"),
                              div(billboarderOutput("schools_details"), align = "center"),
                              h6("Data Source: GCS (placeholder) ", align = "center")
                              
                      
                            )
                          ),
                          
                          br(),
                          br(),
                          fluidRow(
                            column(6,
                                   img(src = "./Images/learn01.jpg", class = "learn01")
                                   ),
                            column(6,
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. "
                                   )
                          ),
                          br(),
                          br(),
                          fluidRow(
                            column(12,
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. "
                                   )),
                          br(),
                          fluidRow(column(
                            6,
                            h3("Percent of College and University Students by Institution", align = "center"),
                                billboarderOutput("students"), 
                            h6(" Data Source: U.S. Department of Education, National Center for Education Statistics, Integrated Postsecondary Education Data System (IPEDS) [2017]", align = "center")
                          ),
                          column(
                            6,
                            h3("Completion Rates for Guilford County's Colleges and Universities", align = "center"),
                                billboarderOutput("completion"),
                            h6(" Data Source: U.S. Department of Education, National Center for Education Statistics, Integrated Postsecondary Education Data System (IPEDS) [2017]", align = "center")
                          )),
                          br(),
                          br(),
                          br(),
                          fluidRow(
                            column(12,
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. "
                                   )),
                          br(),
                          
                          fluidRow(
                            column(6,
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. "
                                 ),
                            column(6,
                                   img(src = "./Images/learn02.jpg", class= "learn02")
                            )
                          ),
                          fluidRow(column(
                            6,
                            h3("Debt to Income Ratio for Guilford County's Colleges and Universities", align = "center"),
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum.",
                            fluidRow(br()),
                             billboarderOutput("debt"),
                            h6(" Data Source: U.S. Department of Education, National Center for Education Statistics, Integrated Postsecondary Education Data System (IPEDS) [2017]", align = "center")
                            
                          ),
                          column(
                            6,
                            h3("Retention Rates for Guilford County's Colleges and Universities", align = "center"),
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum.",
                            fluidRow(br()),
                            billboarderOutput("retention"),
                            h6(" Data Source: U.S. Department of Education, National Center for Education Statistics, Integrated Postsecondary Education Data System (IPEDS) [2017]", align = "center"))
                          ),
                          br(),
                          fluidRow(column(4,
                                          align = "center",
                                          wellPanel(
                                            h3("Community Projects"),
                                            htmlOutput("learn_projects"))
                          ),
                          column(4,
                                 align = "center",
                                 wellPanel(
                                   h3("Resources"),
                                   htmlOutput("learn_resources"))
                          ),
                          column(4,
                                 align = "center",
                                 wellPanel(
                                   h3("What's Missing?"), 
                                   htmlOutput("learn_missing"))
                          )
                          ),
                          br()
                          
                 )),
        
     
        
        #Engage tab ----
        
        tabPanel(title = "ENGAGE", icon = icon("handshake"),
                 tags$div(class = "engage-tab",
                          br(),
                          fluidRow(column(12,
                                          align = "center",
                                          img(src = "./Images/engage.png", class = "sec-bannerImg")
                                          )),
                          br(),
                          fluidRow(
                            column(
                              12,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                              )),
                          br(),
                          
                          fluidRow(
                            
                            column(
                              2,
                              offset = 3,
                              wellPanel(
                                align = "center",
                                HTML("<a href='#vote'><h4> Jump to Vote </h4> </a>")
                              )
                            ),
                            column(
                              2,
                              wellPanel(
                                align = "center",
                                HTML("<a href='#serve'><h4> Jump to Serve </h4> </a>")
                              )
                            ),
                            column(
                              2,
                              wellPanel(
                                align = "center",
                                HTML("<a href='#give'><h4> Jump to Give </h4> </a>")
                              )
                            )
                            
                          ),
                          
                          br(),
                          br(),
                          
                          fluidRow(
                            column(
                              8,
                              offset = 2,
                              img(src = "./Images/act01.jpg", class ="act01")
                            )
                          ),
                          br(),
                          
                          tags$div(fluidRow(
                            class = "subtitle",
                            column(
                              12,
                              align = "center",
                              
                              div(h1("VOTE"),id = "vote")
                              
                            )
                          )),
                          
                          fluidRow(
                            column(12,
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                                   )),
                          fluidRow(
                            column(6,
                                   h3("Race and Party Affliation of Registered Voters", align = "center"),
                                     billboarderOutput("voters_rp"),
                                   h6("Data Source: Jason's Data", align = "center")),
                            column(6,
                                   h3("Gender and Party Affiliation of Registered Voters", align = "center"),
                                     billboarderOutput("voters_gp"),
                                   h6("Data Source: Jason's Data", align = "center")
                                   )
                          ),
                          br(),
                          tags$div(fluidRow(
                            class = "subtitle",
                            column(
                              12,
                              align = "center",
                              
                              div(h1("SERVE"),id = "serve")
                              
                            )
                          )),
                          br(),
                          fluidRow(
                            column(
                              12,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                            )),
                          br(),
                          
                          tags$div(fluidRow(
                            class = "subtitle",
                            column(
                              12,
                              align = "center",
                              
                              div(h1("GIVE"),id = "give")
                              
                            )
                          )),
                          br(),
                          fluidRow(
                            column(
                              12,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac. Urna cursus eget nunc scelerisque viverra mauris in. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Leo integer malesuada nunc vel risus commodo viverra maecenas. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et. Vitae sapien pellentesque habitant morbi tristique. Nisl suscipit adipiscing bibendum est ultricies integer quis auctor. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien."
                            )),
                          br(),
                          
                          fluidRow(
                            column(4,
                                   align = "center",
                                   wellPanel(
                                     h3("Community Projects"),
                                     htmlOutput("engage_projects"))
                            ),
                            column(4,
                                   align = "center",
                                   wellPanel(
                                     h3("Resources"),
                                     htmlOutput("engage_resources"))
                            ),
                            column(4,
                                   align = "center",
                                   wellPanel(
                                     h3("What's Missing?"), 
                                     htmlOutput("engage_missing"))
                            )),
                          br()
                 )
                 
        ),
        
        
        # Explore tab ----
        
        tabPanel(title = "EXPLORE", icon = icon("map-marked-alt"),
                 tags$div(class = "explore-tab"),
                 br(),
                 fluidRow(
                   column(12,
                          align = "center",
                          img(src = "./Images/explore.png", class = "sec-bannerImg")
                   )
                   
                 ), 
                 br(),
                 fluidRow(
                   column(
                     12,
                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris pellentesque. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Urna condimentum mattis pellentesque id. Dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at. Elementum curabitur vitae nunc sed. Urna id volutpat lacus laoreet non curabitur gravida arcu ac."
                   )
                 ),
                 br(),
                 fluidRow(
                   column(
                     12, 
                   leafletOutput("explore_map"))
                 ),
                 br()
                 )
    ))




# Define the UI -----------------------------------------------------------

ui <- fluidPage(theme = "sdashboard.css",
                titlePanel(
                  windowTitle = "Guilford CIP",
                  title = div(
                  img(src = './Images/line.png',class = "lineImg"),
                  img(src = './Images/guilford-logo.png',class= "logoImg"), 
                  img(src = "./Images/guilford.png", class = "bannerImg")
                  
                )
                ),
                div(body, class= "fullpage"))


# Define the server -------------------------------------------------------
server <- function(input, output) {

  # DEMOGRAPHICS Tab ----
    
  location_reactive_d <- reactive({
    input$location_rb_d
  })  
    
  location_reactive_d1 <- reactive({
    input$location_rb_d1
  }) 
  
    output$age <- renderBillboarder({
      
      ages <- ages %>% filter(location ==location_reactive_d()) 
      
      
        billboarder() %>%
            bb_lollipop(data = ages, point_size = 5, point_color = "#617030", line_color = "#617030") %>%
            bb_axis(x =list(height = 80))
        #bb_barchart(data = gc_ages, stacked = T)
    })
    
    output$sex <- renderBillboarder({
      
      sex <- sex %>% filter(location ==location_reactive_d())
      
        billboarder() %>%
            bb_donutchart(data = sex) %>%
            bb_color(palette = c("#113535", "#CB942B", "#89ada7"))
        
        
    })
    
    output$race <- renderBillboarder({
      
      race <- race %>% filter(location ==location_reactive_d1())
      
        billboarder() %>%
            bb_donutchart(data = race) %>%
            bb_donut() %>%
            bb_color(palette = c("#617030", "#CB942B", "#89ada7", "#AC492E", "#071A1E", "#026637", "#113535"))
        
    })
    
    output$ethnicity <- renderBillboarder({
      ethnicity <- ethnicity %>% filter(location ==location_reactive_d1())
      
        billboarder() %>%
            bb_donutchart(data = ethnicity) %>%
            bb_color(palette = c("#AC492E", "#113535", "#CB942B"))
        
    })
    



# LIVE Tab ----

    


output$deaths <- renderBillboarder({
  deaths_un <- deaths %>% filter(manner== "Accident"|manner == "Homicide"| manner == "Suicide"| manner == "Unknown")

  billboarder() %>%
    bb_barchart(data = deaths_un) %>%
    bb_bar(padding =2) %>% 
    bb_y_axis(tick = list(format = suffix("%"))) %>%
    bb_color(palette = c("#ac492e", "#113535", "#88853b", "#3a7993"))


})



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


location_reactive <- reactive({
  input$location_rb
})


output$hh_race <- renderBillboarder({
  
  hh_race_bb <- hh_race %>% 
    filter(location ==location_reactive()) %>% 
    select(levlab, estimate)

  billboarder() %>%
    bb_donutchart(data = hh_race_bb) %>%
    bb_color(palette = c("#E54B21", "#113535", "#617030", "#CB942B", "#89ada7", "#AC492E", "#071A1E", "#026637"))


})



output$tenure_race <- renderBillboarder({
  tenure_bb <- tenure_race %>% 
    filter(location == location_reactive()) %>% 
    mutate(perc = round(perc*100,2)) %>% 
    select(race, perc, tenure)
  
  billboarder() %>% 
    bb_barchart(data = tenure_bb, 
                mapping = bbaes(race, perc, group= tenure)) %>% 
    bb_bar(padding = 2) %>%
    bb_color(palette = c("#E54B21", "#113535", "#617030", "#CB942B", "#89ada7", "#AC492E", "#071A1E", "#026637")) %>% 
    bb_y_axis(tick = list(format = suffix("%"))) %>% 
    bb_axis(x =list(height = 80))
})

output$vacant_houses_map <- renderLeaflet({

  #pal <- colorQuantile(palette = "viridis", domain = vacant_housing$estimate,  probs = seq(0, 1, 0.1))
  vacant_housing <- vacant_housing %>%
    mutate(percent = estimate/Total) %>%
    mutate(percent = ifelse(is.nan(percent), 0, percent)) %>%
    st_transform(crs = "+init=epsg:4326")

  pal <- colorNumeric(palette = "viridis",   domain = vacant_housing$percent)


  leaflet(data = vacant_housing) %>%
    addTiles(options = tileOptions(minZoom = 5)) %>%
    setMaxBounds(-84, 35, -79, 37) %>%
    addPolygons(
      stroke = F,
      fillColor = ~pal(percent),
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
              values = ~ percent,
              labFormat = labelFormat(transform = function(x) 100*x, suffix = "%"),
              title = "Vacant Houses",
              opacity = 1)
})

output$food_stores_map <- renderLeaflet({
  leaflet(data = food_stores) %>%
    addTiles(options = tileOptions(minZoom = 5)) %>%
    setMaxBounds(-84, 35, -79, 37) %>%
    addCircleMarkers(lat = ~lat, lng = ~lon, popup = ~name,
                     stroke = TRUE, fillOpacity = 0.075)
})



output$imr <- renderBillboarder({
  billboarder() %>% 
    bb_barchart(data = imr) %>% 
    bb_legend(show =F) %>% 
    bb_color (palette = c("#CB942B", "#89ada7")) 
})


output$diabetes <- renderUI({
  val <- diabetes %>% 
    pull(indicator_value)
  
  paste(val, "%")
  
})

location_reactive_3 <- reactive({
  input$location_rb3
})

output$snap <- renderUI({
  snap <- snap %>% 
    filter(location == location_reactive_3())
  
  val <- snap %>% 
    pull(perc)
  
  paste(round(val*100,2), "%")
  
})

output$food_insecurity <- renderPlotly({
  
  plot_ly(
    data = food_insecurity, x = ~period_of_measure, y = ~indicator_value/100, type= 'scatter', mode = 'lines+markers',
    line= list(color= '#E54B21', width =2.5),
    marker = list(color= '#E54B21', width =3)
  )  %>% 
    layout(yaxis = list(rangemode = "tozero", title = "Percentage of population <br> that experienced food insecurity", tickformat = "%"),
           xaxis = list(title = ""))
  
})
  

output$live_projects <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(live_projects)){
    ln <- live_projects[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
})

output$live_resources <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(live_resources)){
    ln <- live_resources[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
})

output$live_missing <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(live_missing)){
    ln <- live_missing[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
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

output$work_projects <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(work_projects)){
    ln <- work_projects[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
})

output$work_resources <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(work_resources)){
    ln <- work_resources[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
})

output$work_missing <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(work_missing)){
    ln <- work_missing[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
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
  leaflet(data = filter_parks) %>%
    addTiles(options = tileOptions(minZoom = 5)) %>%
    setMaxBounds(-84, 35, -79, 37) %>%
    addMarkers(lat = ~lat, lng = ~lon, popup = ~name,
               clusterOptions = markerClusterOptions())
})


output$tourism_spending <- renderBillboarder({
  plot <- tourism %>%
    select(year, expenditures, tax_savings)
  
  plot_ly(data = plot) %>%
    add_trace(x =~year, y = ~expenditures, type = 'scatter', mode = 'lines+markers',
              line= list(color= '#113535', width =2.5),
              marker = list(color= '#113535', width =3),
              name = 'Expenditures') %>%
    layout(yaxis = list(title = " Expenditure in Millions", separatethousands = TRUE, side = 'left'),
           xaxis = list(title = "", tickangle = 45, tickfont = list(size = 10)),
           legend = list(orientation = 'h', y = -0.2, x = 0.2))
})

output$play_projects <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(play_projects)){
    ln <- play_projects[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
})

output$play_resources <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(play_resources)){
    ln <- play_resources[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
})

output$play_missing <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(play_missing)){
    ln <- play_missing[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
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
    bb_axis(x =list(height = 75))
  
  
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
  
  gcs %>%
    group_by(school) %>%
    filter(!is.na(value)) %>%
    filter(year == max(year)) %>%
    ungroup() %>%
    mutate(popup = paste0(label_metric, ": ", scales::percent(value), " (", label_school_year, ")")) %>%
    select(school, lat, lng, metric, popup) %>%
    spread(key = metric, value = popup) %>%
    unite(col = popup, kdib, grd3_read, act, hsgrad, post_hs_enrolled, sep = "<BR>", na.rm = T) %>%
    mutate(popup = paste0("<B>", school, "</B><BR><BR>", popup)) %>%
    leaflet() %>%
    addTiles() %>%
    addMarkers(lat = ~lat,
               lng = ~lng,
               popup = ~popup,
               label = ~school,
               layerId = ~school,
               clusterOptions = markerClusterOptions())
  
  # leaflet(data = schools) %>%
  #   addTiles(options = tileOptions(minZoom = 5)) %>%
  #   setMaxBounds(-84, 35, -79, 37) %>%
  #   addMarkers(lat = ~lat, lng = ~lon, popup = ~name,
  #              clusterOptions = markerClusterOptions())
  
  
})

filtered_school <- reactive({
  
  val <- input$schools_map_marker_click$id
  gcs %>% 
    filter(school == val) 
  
  })



output$schools_details <- renderBillboarder({
  validate(
    need(input$schools_map_marker_click$id!= "", "Please click on a school to view performance metrics"),
    errorClass = "errorText"
  )
  
  bb_data <- filtered_school() %>% 
    arrange(year) %>% 
  dplyr::select(label_metric, value, label_school_year)
  
  billboarder() %>% 
    bb_barchart(data = bb_data, 
                mapping = bbaes(label_school_year, value, group= label_metric)) %>% 
    bb_bar(padding = 2) %>% 
    bb_color(palette = c("#E54B21", "#113535", "#617030"))
  
  
})

output$learn_projects <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(learn_projects)){
    ln <- learn_projects[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
})

output$learn_resources <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(learn_resources)){
    ln <- learn_resources[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
})

output$learn_missing <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(learn_missing)){
    ln <- learn_missing[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
})

# ENGAGE Tab ----



output$projects <- renderUI({
  
  vec <- vector()
  
  for(i in 1:nrow(projects)){
    ln <- projects[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
  
})


output$resources <- renderUI({
  
  vec <- vector()
  
  for(i in 1:nrow(resources)){
    ln <- resources[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
  
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

output$engage_projects <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(engage_projects)){
    ln <- engage_projects[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
})

output$engage_resources <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(engage_resources)){
    ln <- engage_resources[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
})

output$engage_missing <- renderUI({
  vec <- vector()
  
  for(i in 1:nrow(engage_missing)){
    ln <- engage_missing[i,1]
    ln1 <- paste(i, ": ", ln)
    vec <- append(vec, ln1)
  }
  HTML(paste(vec, collapse = "<br>"))
})

# CIVIC Tab ----


# EXPLORE Tab ----

output$explore_map <- renderLeaflet({
  exploremap <- leaflet()
  
  walk(explore_acsdata, function(layer) {
    
    #Build palette
    palette <- colorNumeric(
      palette = "viridis",
      domain = layer$estimate
    )
    
    group <- layer %>% slice(1) %>% pull(short_title)
    
    popup <- layer %>%
      transmute(popup = glue("<B>Zip Code: {geoid}</B><BR>
                           <B>{concept}</B><BR><BR>
                           {format(estimate, big.mark = ',')}")) %>%
      pull(popup)
    
    #str_replace_all(str_wrap(concept, width = 20, exdent = 3), '\n', '<BR>')
    
    
    exploremap <<- exploremap %>%
      #addTiles(options = tileOptions(minZoom = 5), group = group) %>%
      setMaxBounds(-80, 35, -78, 37) %>%
      addPolygons(data = layer,
                  group = group,
                  stroke = F,
                  fillColor = ~palette(estimate),
                  fillOpacity = 0.7,
                  popup = popup
      ) #%>%
    # addLegend(pal = palette,
    #           values = layer$estimate,
    #           group = group,
    #           position = "bottomleft",
    #           title = group
    #           )
    
    
    
  })
  
  exploremap <- exploremap %>%
    addTiles(options = tileOptions(minZoom = 5)) %>%
    addLayersControl(baseGroups = explore_acsdata %>% map_chr(~.x %>% slice(1) %>% pluck("short_title")) %>% unname(),
                     overlayGroups = c("Schools", "Parks", "Food Stores"),
                     position = "bottomright",
                     options = layersControlOptions(collapsed = F)) %>%
    hideGroup(c("Schools", "Parks", "Food Stores")) %>%
    addLegend(pal = colorNumeric(palette = "viridis", domain = c(0,1)),
              values = c(0, 1),
              position = "bottomleft",
              title = "Scale"
    )
  
  exploremap <- exploremap %>%
    addCircleMarkers(data = food_stores,
                     lat = ~lat, lng = ~lon, popup = ~name,
                     stroke = TRUE, fillOpacity = 0.075,
                     group = "Food Stores") %>%
    addMarkers(data = schools,
               lat = ~lat, lng = ~lon, popup = ~name,
               clusterOptions = markerClusterOptions(),
               group = "Schools") %>%
    addMarkers(data = filter_parks,
               lat = ~lat, lng = ~lon, popup = ~name,
               clusterOptions = markerClusterOptions(),
               group = "Parks")
  
  exploremap
})



}


# Run the app -------------------------------------------------------------
shinyApp(ui, server)
