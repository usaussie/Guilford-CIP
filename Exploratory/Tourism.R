library(siverse)
library(tidyverse)
library (plotly)



# Load data ---------------------------------------------------------------

#tourism <- read_xlsx("G:/My Drive/SI/DataScience/data/Guilford County CIP/Web Sources/Travel Expenditures GC.xlsx")
tourism <- read_xlsx("C:/Users/u1106978/Desktop/Travel Expenditures GC.xlsx") %>% 
  clean_names() %>% filter(!is.na(year))

tourism <- tourism %>% mutate(expenditures = as.numeric(expenditures), 
                              tax_savings = as.numeric(tax_savings))


plot <- tourism %>% 
  select(year, expenditures, tax_savings)





#save(tourism, file = "G:/My Drive/SI/DataScience/data/Guilford County CIP/dashboard/tourism.rda")


plot_ly(data = plot) %>% 
  add_trace(x =~year, y = ~expenditures, type = 'scatter', mode = 'lines+markers',
        line= list(color= '#113535', width =2.5),
        marker = list(color= '#113535', width =3),
        name = 'Expenditures') %>% 
  layout(yaxis = list(title = " Expenditure in Millions", separatethousands = TRUE, side = 'left'),
         xaxis = list(title = "", tickangle = 45, tickfont = list(size = 10)),
         legend = list(orientation = 'h', y = -0.2, x = 0.2))
