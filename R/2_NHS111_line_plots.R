library(tidyverse)
library(lubridate)
library(THFstyle)
library(ggrepel)

NHS111 <- readRDS(here::here('data', 'NHS111.RDS'))


THF_red <- '#dd0031'
THF_50pct_light_blue <- '#53a9cd'


national <- NHS111 %>% 
  group_by(date) %>% 
  mutate(total_nat=sum(total)) %>% 
  group_by(ageband, date) %>% 
  mutate(total_ageband=sum(total)) %>% 
  group_by(sex, date) %>% 
  mutate(total_sex=sum(total)) %>% 
  ungroup()

ggplot(national, aes(x=date, y=total_nat)) + 
  geom_line(colour=THF_red) + geom_point(colour=THF_red, size=2, fill='white') +
  geom_point(color='white', size=1) + theme_THF() + 
  scale_x_date(date_breaks = "2 day") + scale_y_continuous(labels = scales::comma, limits = c(0, NA)) +
  theme(plot.title = element_text(hjust = -0.1)) + 
  labs(caption='Source: NHS Digital', x='', y='', title='Completed online assessments in NHS 111 Online')
ggsave(filename=here::here('output', 'NHS111online.png') ) 


# Plot by ageband  
# data for labels  
national_19_69<- national %>% 
    filter(date==max(date), ageband=='19-69 years') %>% 
    pull(total_ageband) %>% 
    unique()
  national_label <- national %>% 
    group_by(ageband) %>% 
    mutate(label=ifelse(date==max(date), ageband, ''))
p <-  national_label %>% 
    distinct(date, .keep_all = TRUE) %>% 
  ggplot(.) + 
    geom_line(aes(x=date, y=total_ageband, colour=ageband, group=ageband)) + 
    geom_point(aes(x=date, y=total_ageband, colour=ageband), size=2, fill='white') +
    geom_point(aes(x=date, y=total_ageband), color='white', size=1) + 
    geom_text_repel(aes(x=date, y=total_ageband, label=label, colour=ageband)) + theme_THF() + 
    scale_x_date(date_breaks = "1 day") + 
    scale_y_continuous(labels = scales::comma, limits = c(0, NA)) + 
    scale_colour_THF() + ylab('') + xlab('') +
    theme(plot.title = element_text(hjust = -0.5)) + 
  labs(caption='Source: NHS Digital', title = 'Completed online assessments in NHS 111 Online')
ggsave(filename=here::here('output', 'NHS111online_ageband.png') ) 

# By sex
label_date=max(national$date)-1
ggplot(national) + 
    geom_line(aes(x=date, y=total_sex, colour=sex, group=sex)) + 
    geom_point(aes(x=date, y=total_sex, colour=sex), size=2, fill='white') +
    geom_point(aes(x=date, y=total_sex), color='white', size=1) + theme_THF() + 
    scale_x_date(date_breaks = "2 day") + 
    scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_colour_THF() + ylab('') + xlab('') +
    theme(plot.title = element_text(hjust = -0.5), legend.position = 'None') +
    annotate(geom='text', x=label_date, y=10000, label='Male', colour=THF_50pct_light_blue) +
    annotate(geom='text', x=label_date, y=44000, label='Female', colour=THF_red) +
    labs(caption='Source: NHS Digital', title='Completed online assessments in NHS 111 Online')
ggsave(filename=here::here('output', 'NHS111online_sex.png') ) 
  