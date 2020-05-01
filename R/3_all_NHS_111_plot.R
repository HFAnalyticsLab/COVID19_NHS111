library(THFstyle)
library(tidyverse)

all_NHS_111 <-readRDS(here::here('data', 'all_NHS_111'))
THF_red <- '#dd0031'
national <- all_NHS_111 %>% 
  group_by(period ) %>% 
  summarise(calls = sum(as.numeric(total_calls_offered)), 
            calls_aband=sum(as.numeric(no_of_abandoned_calls))) %>% 
  mutate(period=lubridate::date(period))

national %>% 
  filter(period>='2018-01-01') %>% 
  ggplot(., aes(x=period, y=calls)) + 
  geom_line(colour=THF_red) + 
  geom_point(colour=THF_red, size=2, fill='white') +
  geom_point(color='white', size=1) +
  scale_x_date() + 
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.8,0.5)) +
  labs(caption='Source: NHS England', 
       title='Total received calls NHS 111')

ggsave(here::here('output','all_NHS111.png'))
