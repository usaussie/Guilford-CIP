library(siverse)
library(tidyverse)
library(googlesheets)
library(leaflet)
library(billboarder)
library(plotly)
library(scales)

edu <- get(load("G:/My Drive/ACS/2017 5-year/acs_educ_over25years_lst.RData"))

####################################################################

#Pie Chart - Percentage split of Nation with differing educations
eduNationSplit <- edu$place %>% 
  filter(completed_bucket != "Total") %>% 
  group_by(completed_bucket) %>%
  summarise(total = sum(bucket_value)) %>% 
  select(completed_bucket, total) %>% 
  mutate(total = total/sum(total) * 100) %>% 
  mutate(total = round(total, digits=2))

pieNationLabel <- paste(eduNationSplit$completed_bucket, eduNationSplit$total) %>% 
  paste("%", sep="")

pie(eduNationSplit$total, labels=pieNationLabel, main = "Education Levels at Nation Level")

####################################################################

#Pie Chart - Percentage split of State with differing educations
eduStateSplit <- edu$place %>% 
  filter(completed_bucket != "Total") %>% 
  filter(state == "NC") %>% 
  group_by(completed_bucket) %>% 
  summarise(total = sum(bucket_value)) %>% 
  select(completed_bucket, total) %>% 
  mutate(total = total/sum(total)*100) %>% 
  mutate(total = round(total, digits=2))

pieStateLabel <- paste(eduNationSplit$completed_bucket, eduNationSplit$total) %>% 
  paste("%", sep="")

pie(eduStateSplit$total, labels=pieStateLabel, main = "Education Levels at State Level")

####################################################################

#Pie Chart - Percentage split of County with differing educations
eduCountySplit <- edu$place %>% 
  filter(completed_bucket != "Total") %>% 
  filter(state == "NC", str_detect(county, "Guilford")) %>% 
  group_by(completed_bucket) %>% 
  summarise(total = sum(bucket_value)) %>% 
  select(completed_bucket, total) %>% 
  mutate(total = total/sum(total)*100) %>% 
  mutate(total = round(total, digits=2))

pieCountyLabel <- paste(eduCountySplit$completed_bucket, eduCountySplit$total) %>% 
  paste("%", sep="")

pie(eduCountySplit$total, labels=pieCountyLabel, main = "Education Levels at County Level")

####################################################################

# Bar Chart of the education binned by cities in Guilford County
# Numbers
eduPlace <- edu$place %>% 
  filter(completed_bucket != "Total", value_type=="estimate") %>% 
  filter(str_detect(county, "Guilford")) %>% 
  select(city, completed_bucket, bucket_value) %>% 
  spread(completed_bucket, bucket_value) 

billboarder() %>% 
  bb_barchart(data = eduPlace) %>% 
  bb_labs(title = "Education Binned By Cities In Guilford County")

# Percentage
eduPlace <- edu$place %>% 
  filter(completed_bucket != "Total", value_type=="estimate") %>% 
  filter(str_detect(county, "Guilford")) %>% 
  select(city, completed_bucket, bucket_value) %>%
  group_by(city) %>% 
  mutate(total=sum(bucket_value)) %>% 
  ungroup() %>% 
  mutate(percentageByCity = (bucket_value)/total*100) %>% 
  select(completed_bucket, percentageByCity, city) %>% 
  spread(completed_bucket, percentageByCity)

billboarder() %>% 
  bb_barchart(data = eduPlace) %>% 
  bb_labs(title = "Education Binned By Cities In Guilford County")


####################################################################

# Bar Chart of the education binned by States throughout Nation
# Numbers
eduStates <- edu$place %>% 
  filter(completed_bucket != "Total", value_type=="estimate") %>% 
  filter(state != 'NA') %>% 
  select(state, completed_bucket, bucket_value) %>%
  group_by(state, completed_bucket) %>% 
  summarise(total = sum(bucket_value)) %>% 
  spread(completed_bucket, total)

billboarder() %>% 
  bb_barchart(data = eduStates) %>% 
  bb_labs(title = "Education Binned By States In Nation")

# Percentage
eduStatesPercentage <- edu$place %>% 
  filter(completed_bucket != "Total", value_type=="estimate") %>% 
  filter(state != 'NA') %>% 
  select(state, completed_bucket, bucket_value) %>%
  group_by(state, completed_bucket) %>% 
  summarise(total=sum(bucket_value)) %>% 
  ungroup() %>% 
  group_by(state) %>% 
  mutate(total1 = sum(total)) %>% 
  mutate(perc = total/total1 * 100) %>% 
  select(completed_bucket, perc, state) %>% 
  spread(completed_bucket, perc)

billboarder() %>% 
  bb_barchart(data = eduStatesPercentage) %>% 
  bb_labs(title = "Education Binned By States In Nation")


####################################################################
# Bar Chart of education binned by counties in North Carolina
# Numbers
eduNC <- edu$place %>% 
  filter(completed_bucket != "Total", value_type=="estimate") %>% 
  filter(state == 'NC') %>% 
  group_by(county, completed_bucket) %>% 
  summarise(total = sum(bucket_value)) %>% 
  spread(completed_bucket, total) 

billboarder() %>% 
  bb_barchart(data = eduNC) %>% 
  bb_labs(title = "Education Binned By Counties in North Carolina")

# Percentage
eduNC <- edu$place %>% 
  filter(completed_bucket != "Total", value_type=="estimate") %>% 
  filter(state == 'NC') %>% 
  select(county, completed_bucket, bucket_value) %>%
  group_by(county, completed_bucket) %>% 
  summarise(total=sum(bucket_value)) %>% 
  ungroup() %>% 
  group_by(county) %>% 
  mutate(total1 = sum(total)) %>% 
  mutate(perc = (total/total1)*100) %>% 
  select(completed_bucket, perc, county) %>% 
  spread(completed_bucket, perc)

billboarder() %>% 
  bb_barchart(data = eduNC) %>% 
  bb_labs(title = "Education Binned By Counties in North Carolina")





