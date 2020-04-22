library(tidyverse)
library(lubridate)
library(THFstyle)

pathways <- readRDS(here::here('data', 'pathways.RDS'))
THF_red <- '#dd0031'
THF_50pct_light_blue <- '#53a9cd'
THF_1_purple <- '#744284'


national <- pathways %>% 
  group_by(date) %>% 
  mutate(total_nat=sum(triagecount)) %>% 
  group_by(ageband, date) %>% 
  mutate(total_ageband=sum(triagecount)) %>% 
  group_by(sex, date) %>% 
  mutate(total_sex=sum(triagecount)) %>% 
  ungroup()

ggplot(national, aes(x=date, y=total_nat)) + 
  geom_line(colour=THF_red) + 
  geom_point(colour=THF_red, size=2, fill='white') +
  geom_point(color='white', size=1) + theme_THF() + 
  scale_x_date(date_breaks = "2 day") + scale_y_continuous(labels = scales::comma, limits = c(0, NA)) +
  theme(plot.title = element_text(hjust = -0.1)) + 
  labs(caption='Source: NHS Digital', x='', y='', title = 'NHS pathway triages through 111 and 999' )
ggsave(filename=here::here('output', 'pathways_nat.png') ) 


# by ageband  
# data for labels  
national_19_69<- national %>% 
  filter(date==max(date), ageband=='19-69 years') %>% 
  pull(total_ageband) %>% 
  unique()

ggplot(national) + 
  geom_line(aes(x=date, y=total_ageband, colour=ageband, group=ageband)) + 
  geom_point(aes(x=date, y=total_ageband, colour=ageband), size=2, fill='white') +
  geom_point(aes(x=date, y=total_ageband), color='white', size=1) + theme_THF() + scale_x_date(date_breaks = "1 day") + 
  scale_y_continuous(labels = scales::comma, limits = c(0, NA)) + scale_colour_THF() + ylab('') + xlab('') +
  ggtitle('NHS pathway triages through 111 and 999') + 
  theme(plot.title = element_text(hjust = -0.1)) + 
  labs(caption='Source: NHS Digital')
ggsave(filename=here::here('output', 'pathways_ageband.png') ) 


# By sex
label_date=max(national$date)-1
ggplot(national) + 
  geom_line(aes(x=date, y=total_sex, colour=sex, group=sex)) + 
  geom_point(aes(x=date, y=total_sex, colour=sex), size=2, fill='white') +
  geom_point(aes(x=date, y=total_sex), color='white', size=1) + 
  theme_THF() + scale_x_date(date_breaks = "1 day") + theme(legend.position = 'None') +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + 
  scale_colour_THF() + ylab('') + xlab('') +
  ggtitle('NHS pathway triages through 111 and 999') + 
  annotate(geom='text', x=label_date, y=5500, label='Male', colour=THF_50pct_light_blue) +
  annotate(geom='text', x=label_date, y=9000, label='Female', colour=THF_red) +
  annotate(geom='text', x=label_date, y=1000, label='Unknown', colour=THF_1_purple) +
  labs(caption='Source: NHS Digital')
ggsave(filename=here::here('output', 'pathways_sex.png') ) 
 