library(tidyverse)
library(lubridate)
library(THFstyle)

pathways <- readRDS(here::here('data', 'pathways.RDS'))
THF_red <- '#dd0031'
THF_50pct_light_blue <- '#53a9cd'
THF_1_purple <- '#744284'


national_pathways <- pathways %>% 
  group_by(gender, ageband) %>% 
  mutate(total_nat_gender=sum(triagecount)) %>% 
  group_by(gender, date, ageband) %>% 
  mutate(total_gender_date=sum(triagecount)) %>% 
  ungroup() %>% 
  mutate(total_gender_date=ifelse(gender=='Female',-total_gender_date, total_gender_date ),
         total_nat_gender=ifelse(gender=='Female',-total_nat_gender, total_nat_gender ) )

ggplot(national_pathways, aes(x = ageband, y = total_gender_date, fill = gender)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() + 
  theme(panel.grid.major.x=element_line(colour='grey90'), 
        panel.grid.major.y=element_blank(), legend.position = 'none') +
  labs(y = "", x = "", title = "NHS pathway triages through 111 and 999") +
  scale_fill_THF() + facet_wrap(vars(date)) + scale_y_continuous(labels = scales::comma)
ggsave(here::here('output', 'pop_pyramid_pathways_ver_time.png' ))

ggplot(national_pathways, aes(x = ageband, y = total_nat_gender, fill = gender)) +
  geom_bar(stat = "identity") + 
  coord_flip() + 
  theme_THF() + theme(panel.grid.major.x=element_line(colour='grey90'), panel.grid.major.y=element_blank()) +
  labs(y = "", x = "", title = "NHS pathway triages through 111 and 999") +
  scale_fill_THF() + scale_y_continuous(labels = scales::comma)
ggsave(here::here('output', 'pop_pyramid_pathways.png' ))
