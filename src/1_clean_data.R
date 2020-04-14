# data from
# https://digital.nhs.uk/data-and-information/publications/statistical/mi-potential-covid-19-symptoms-reported-through-nhs-pathways-and-111-online/latest
library(tidyverse)
## NHS 111 data
NHS111 <- read_csv(here::here('data',
                              "111 Online Covid-19 data_2020-04-13.csv"))
NHS111 <- NHS111 %>% 
  mutate(date=lubridate::dmy(journeydate)) %>% 
  set_names(tolower(names(.))) %>% 
  janitor::clean_names()

saveRDS(NHS111,here::here('data', 'NHS111.RDS'))

## NHS pathways
pathways <- read_csv(here::here('data', 
                                "NHS Pathways Covid-19 data 2020-04-13.csv"))
pathways <- pathways %>% 
  set_names(tolower(names(.))) %>% 
  janitor::clean_names() %>% 
  mutate(date=lubridate::dmy(call_date)) 

saveRDS(pathways,here::here('data', 'pathways.RDS'))
