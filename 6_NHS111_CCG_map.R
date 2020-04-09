library(sf)
library(leaflet)
library(tidyverse)
library(lubridate)
library(ggthemes)
library(THFstyle)

sf <- st_read(here::here('data', 'map') )

NHS111 <- readRDS(here::here('data', 'NHS111.RDS'))
CCG_to_STP <- read_csv(here::here('data',"Clinical_Commissioning_Group_to_STPs_April_2019_Lookup_in_England.csv"))
NHS111 <-left_join(NHS111, CCG_to_STP, by=c('ccgcode'='CCG19CD'))
THF_red <- '#dd0031'
THF_50pct_light_blue <- '#53a9cd'


national <- NHS111 %>% 
  group_by(date, ccgcode) %>% 
  mutate(total_nat=sum(total)) %>% 
  group_by(ageband, date, ccgcode) %>% 
  mutate(total_ageband=sum(total)) %>% 
  group_by(gender, date, ccgcode) %>% 
  mutate(total_gender=sum(total)) %>% 
  ungroup() 
## Cutting national$total_nat into national$total_nat_rec
national$total_nat_rec <- cut(national$total_nat, include.lowest=TRUE,  right=TRUE,
                              breaks=c(0,250, 500,750, 1000, 1250,1500))  
national_small <- national %>% 
  distinct(ccgcode, .keep_all = TRUE ) 
national_map <- left_join(sf, national_small, by=c('ccg19cd'='ccgcode'))
not_in_map_data <- anti_join(sf, national, by=c('ccg19cd'='ccgcode')) 
not_in_nhs111_data <- anti_join(national, sf, by=c('ccgcode'='ccg19cd')) %>% 
  distinct(ccgcode, .keep_all = TRUE)


england <-  ggplot(national_map) + geom_sf(aes(fill=total_nat_rec)) + theme_map()  + scale_fill_THF() +
  labs(title='NHS111 calls') + theme(legend.position='top', 
                                     legend.justification='left')
ggsave(here::here('output', 'NHS111_map.png'))

london <- national_map %>% 
  filter(str_detect(STP19NM, 'London'))

london_map <- ggplot(london) + geom_sf(aes(fill=total_nat_rec)) + theme_map()  + scale_fill_THF() +
  theme(legend.position='none', 
                                     legend.justification='left')
