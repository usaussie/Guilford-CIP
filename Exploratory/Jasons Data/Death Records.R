require(tidyverse)
require(siverse)
require(ggridges)


# Dictionary ------------------------------------------------------------------------------------------------------

dicdr <- read_excel("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/2014 DEATH DETAIL DESCRIPTION_NS.XLS") %>%
  clean_names()

dicdr <- dicdr %>% fill(everything())

dicdr <- dicdr %>%
  mutate(name = make_clean_names(name))

dicdr <- dicdr %>%
  mutate(variable = str_remove(variable, "Decedent's Race--"))


# Data ------------------------------------------------------------------------------------------------------------

dr <- read_csv("~/Google Drive/SI/DataScience/data/Guilford County CIP/From Jason/death_records_test.csv", guess_max = 553841) %>%
  clean_names() %>%
  remove_empty(which = "cols")

dr <- dr %>%
  mutate(age = as.integer(age),
         dob = paste(dob_yr, dob_mo, dob_dy, sep = "-"),
         dob = ymd(dob))

#Race
dicdr %>% filter(str_detect(name, "race")) %>%
  select(variable, name) %>%
  spread(name, variable)


dr <- dr %>%
  mutate(race1 = ifelse(race1 == "Y", "White", NA),
         race2 = ifelse(race2 == "Y", "Black", NA),
         race3 = ifelse(race3 == "Y", "AIAN", NA),
         race4 = ifelse(race4 == "Y", "Asian Indian", NA),
         race5 = ifelse(race5 == "Y", "Chinese", NA),
         race6 = ifelse(race6 == "Y", "Filipino", NA),
         race7 = ifelse(race7 == "Y", "Japanese", NA),
         race8 = ifelse(race8 == "Y", "Korean", NA),
         race9 = ifelse(race9 == "Y", "Vietnamese", NA),
         race10 = ifelse(race10 == "Y", "Other Asian", NA),
         race11 = ifelse(race11 == "Y", "Native Hawaiian", NA),
         race12 = ifelse(race12 == "Y", "Guamanian or Chamorro", NA),
         race13 = ifelse(race13 == "Y", "Samoan", NA),
         race14 = ifelse(race14 == "Y", "Other Pacific Islander", NA),
         race15 = ifelse(race15 == "Y", "Other", NA),
         )

#Manner
dr <- dr %>%
  mutate(manner = case_when(manner == "N" ~ "Natural",
                            manner == "A" ~ "Accident",
                            manner == "S" ~ "Suicide",
                            manner == "H" ~ "Homicide",
                            manner == "P" ~ "Pending",
                            manner == "C" ~ "Can't Determine",
                            is.na(manner) ~ "Unknown"))

dr %>%
  select(-(race16:race23)) %>%
  unite(col = "race", starts_with("race"), na.rm = T) %>%
  count(race)

dr <- dr %>%
  mutate(whiteblack = case_when(race2 == "Black" ~ "Black",
                                race1 == "White" ~ "White",
                                is.na(race1) & is.na(race2) ~ "Other"))

dr %>%
  filter(age <= 135, sex != "U", whiteblack != "Other") %>%
  ggplot(aes(x = age, y = whiteblack, fill = whiteblack)) + geom_density_ridges() +
  scale_fill_manual(values = c("black", "white")) + theme_ridges() + guides(fill = F)

dr %>%
  filter(age <= 135, sex != "U", whiteblack != "Other") %>%
  ggplot(aes(x = dod_yr, y = age, color = whiteblack)) + geom_point() + geom_smooth()


dr %>%
  filter(age <= 135, sex != "U", whiteblack != "Other") %>%
  unite(sexrace, whiteblack, sex) %>%
  tabyl(manner, sexrace) %>%
  adorn_percentages("col") %>%
  untabyl() %>%
  filter(manner != "Natural") %>%
  gather(sexrace, pct, -manner) %>%
  separate(sexrace, into = c("Race", "Sex")) %>%
  ggplot(aes(x = manner, y = pct, fill = Race, color = Sex)) + geom_col(position = "dodge", size = 2) + scale_y_continuous(labels = scales::percent) + scale_fill_manual(values = c("black","white")) + scale_color_manual(values = c("pink", "lightblue"))


  ggplot(aes(x = manner, fill = whiteblack)) + geom_bar() + facet_wrap(~sex)


dr %>%
  filter(age <= 135, sex != "U", whiteblack != "Other") %>%
  unite(sexrace, whiteblack, sex) %>%
  tabyl(manner, veteran, sexrace) %>%
  adorn_percentages("col") %>%
  adorn_pct_formatting()

dr %>%
  filter(age <= 135, sex != "U", whiteblack != "Other") %>%
  filter(manner == "Suicide") %>%
  tabyl(veteran, whiteblack, sex) %>%
  adorn_percentages("col") %>%
  adorn_pct_formatting()