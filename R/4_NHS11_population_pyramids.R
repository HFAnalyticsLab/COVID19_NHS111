library(tidyverse)
library(lubridate)
library(THFstyle)

NHS111 <- readRDS(here::here('data', 'NHS111.RDS'))

THF_red <- '#dd0031'
THF_50pct_light_blue <- '#53a9cd'

national_nhs111 <- NHS111 %>% 
  group_by(sex, ageband) %>% 
  mutate(total_nat_sex=sum(total)) %>% 
  group_by(sex, date, ageband) %>% 
  mutate(total_sex_date=sum(total)) %>% 
  ungroup() %>% 
  mutate(total_sex_date=ifelse(sex=='Female',-total_sex_date, total_sex_date ),
         total_nat_sex=ifelse(sex=='Female',-total_nat_sex, total_nat_sex ) )


ggplot(national_nhs111, aes(x = ageband, y = total_sex_date, fill = sex)) +
geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() + 
  theme(panel.grid.major.x=element_line(colour='grey90'), 
        panel.grid.major.y=element_blank(), legend.position = 'none') +
  labs(y = "", x = "", title = "Completed online assessments in NHS 111 Online") +
  scale_fill_THF() + facet_wrap(vars(date)) + scale_y_continuous(labels = scales::comma)
ggsave(here::here('output', 'pop_pyramid_NHS11_ver_time.png' ))

ggplot(national_nhs111, aes(x = ageband, y = total_nat_sex, fill = sex)) +
  geom_bar(stat = "identity") + 
  coord_flip() + 
  theme_THF() + theme(panel.grid.major.x=element_line(colour='grey90'), panel.grid.major.y=element_blank()) +
  labs(y = "", x = "", title = "Completed online assessments in NHS 111 Online") +
  scale_fill_THF() + scale_y_continuous(labels = scales::comma)
ggsave(here::here('output', 'pop_pyramid_NHS11.png' ))
