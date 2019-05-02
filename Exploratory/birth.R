library(siverse)
library(tidyverse)
library(plotly)

currentYr <- 2019


births_all<- read_csv("G:/My Drive/SI/DataScience/data/Guilford County CIP/From Jason/birthRecordsMaster.csv")

current_yr <- 2019

#the data is super sparse for before 2012, not going to use that. There's also a couple data entry errors: filtering that out too

births <- births_all %>% 
  mutate(yob = year(ChildDOB)) %>% 
  count(Gender, yob) %>% 
  filter(yob>2012) %>% 
  filter(yob <current_yr) %>% 
  filter(Gender=="M"|Gender == "F") %>% 
  mutate(Gender = case_when(Gender == "M"~"Males",
                            Gender == "F"~"Females")) %>% 
  spread(Gender,n)

#save(births, file = "G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/births.rda")

p <- plot_ly(data = births, x =~yob, y = ~Females, type = 'scatter', mode = 'lines+markers', 
             line= list(color= 'rgb(104,77,232)', width =2.5), 
             marker = list(color= 'rgb(104,77,232)', width =3), 
             name = 'Females') %>% 
  add_trace(y=~Males, line = list(color='rgb(145, 150, 54)'), 
            marker = list(color= 'rgb(145, 150, 54)'),
            name = 'Males') %>% 
  layout(yaxis = list(title = "", separatethousands = TRUE),
         xaxis = list(title = "", tickangle = 45, tickfont = list(size = 10)),
         legend = list(orientation = 'h', y = -0.2, x = 0.2))

p  
