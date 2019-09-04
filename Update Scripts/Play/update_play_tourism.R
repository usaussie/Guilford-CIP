# tourism spending data from https://partners.visitnc.com/economic-impact-studies

library(tidyverse)

# On the page, use the dropdown for county specific data and select Guilford County

# Copy the data and save it as travel_expenditures.xlsx in the Web Sources folder (within Updated data)

tourism <- read_xlsx("./Updated data/Web Sources/travel_expenditures.xlsx") %>% 
  clean_names() %>% 
  filter(!is.na(year)) %>% 
  mutate(expenditures = as.numeric(expenditures), 
         tax_savings = as.numeric(tax_savings)) %>% 
  select(year, expenditures, tax_savings)


save(tourism, file = "./Updated data/tourism.rda")
