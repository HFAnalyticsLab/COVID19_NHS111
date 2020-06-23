library(THFstyle)
library(tidyverse)
library(lubridate)
library(patchwork)

all_NHS_111 <-readRDS(here::here('data', 'all_NHS_111'))
THF_red <- '#dd0031'

# Automating plots
population_denom <- c("total_calls_offered", "no_of_abandoned_calls", "no_calls_answered", "calls_answered_within_60_secs", "no_calls_triaged", "calls_transfered_to_clinical_advisor", "warm_transfered_to_clinical_advisor", "person_offered_call_back", "calls_back_within_10_min", "calls_to_a_clinician", "ambulance_dispatches", "recommended_to_attend_a_e", "recommended_to_attend_primary_care", "recommended_to_contact_primary_care", "recommended_to_speak_to_primary_care", "recommended_to_dental_pharmacy", "recommended_to_dental", "recommended_to_pharmacy", "recommended_to_attend_other_service", "not_recommended_to_attend_other_service", "given_health_information", "recommended_home_care", "recommended_non_clinical")
calls_answered_denom <- c(  "calls_answered_within_60_secs", "no_calls_triaged", "calls_transfered_to_clinical_advisor", "warm_transfered_to_clinical_advisor", "person_offered_call_back", "calls_back_within_10_min", "calls_to_a_clinician", "ambulance_dispatches", "recommended_to_attend_a_e", "recommended_to_attend_primary_care", "recommended_to_contact_primary_care", "recommended_to_speak_to_primary_care", "recommended_to_dental_pharmacy", "recommended_to_dental", "recommended_to_pharmacy", "recommended_to_attend_other_service", "not_recommended_to_attend_other_service", "given_health_information", "recommended_home_care", "recommended_non_clinical")

calls_answered_denom <- c(  "calls_answered_within_60_secs", "no_calls_triaged", "calls_transfered_to_clinical_advisor", "warm_transfered_to_clinical_advisor", "person_offered_call_back", "calls_back_within_10_min", "calls_to_a_clinician", "ambulance_dispatches", "recommended_to_attend_a_e", "recommended_to_attend_primary_care", "recommended_to_contact_primary_care", "recommended_to_speak_to_primary_care", "recommended_to_dental_pharmacy", "recommended_to_dental", "recommended_to_pharmacy", "recommended_to_attend_other_service", "not_recommended_to_attend_other_service", "given_health_information", "recommended_home_care", "recommended_non_clinical")



national <- all_NHS_111 %>% 
  mutate(period=lubridate::date(period)) %>% 
  filter(period>= '2019-03-01') %>% 
  mutate(period=floor_date(period, unit = 'month')) %>% 
  mutate_at(vars(-c(concat, region, provider, period,  code, area )), as.numeric) %>% 
  group_by(period ) %>% 
  summarise_if(is.numeric, sum) %>% 
  mutate_at(calls_answered_denom, list(calls_ans_p=~.x/no_calls_answered )) %>% 
  mutate_at(population_denom, list(pop_p=~.x/population )) 

national_long <- pivot_longer(data = national,
                              -period,
                              names_to = 'type')

national_long %>% 
  filter(str_detect(type, 'recommended_to_attend')) %>% 
  filter(!str_detect(type, '_p')) %>% 
ggplot(., aes(x=period, y=value, group=type)) + 
  geom_line(aes(colour=type) )+ 
  geom_point(aes(colour=type), size=2, fill='white') +
  geom_point(color='white', size=1) + scale_colour_THF() +
  scale_x_date(date_breaks = "2 month") + 
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = 'bottom') +
  labs(caption='Source: NHS England', 
       title='')

## national with average

previous_year <- all_NHS_111 %>% 
  # filter(period>= '2014-04-01' & period<= '2019-04-01' ) %>% 
  filter(period>= '2018-06-01' & period<= '2019-06-01' ) %>% 
  mutate_at(vars(-c(concat, region, provider, period,  code, area )), as.numeric) %>% 
  group_by(period ) %>% 
  summarise(across(where(is.numeric), sum)) %>% 
  mutate(month=month(period), .before=1) %>% 
    group_by(month) %>% 
  mutate(across(where(is.numeric), mean)) %>%
  select(-period) %>% 
  distinct(month, .keep_all = TRUE) %>% 
  mutate(period=case_when(month<=5 ~ date(paste0('2020-', month,'-01')),
                          month>5 ~ date(paste0('2019-', month,'-01'))), .before = 1)

two_years_wide <- national %>% 
  filter(period>='2019-06-01') %>% 
  select(-contains('_p')) %>% 
  left_join(previous_year, by='period', suffix=c('_current','_previous')) %>% 
  select(-contains('population')) %>% 
  select(period, contains('total_calls_offered'), contains('no_calls_answered'), contains('recommended_to')) %>% 
  mutate(across(-period, round)) %>% 
  mutate(month=month(period, label = TRUE))

two_years_wide %>% 
  select(period, month, contains('_a_e')) %>% 
  write_csv(here::here('data', 'two_years_wide_nhs_111_ae.csv'))  

two_years_wide %>% 
  select(period, month, contains('total_calls_offered'), contains('no_calls_answered')) %>% 
  write_csv(here::here('data', 'two_years_wide_nhs_111_calls_offered_answered.csv'))  

  
two_years <- national %>% 
  bind_rows(previous_year, .id = 'previous')
calls_ans <- two_years %>%
  mutate(previous=case_when(previous==1 ~ '2019-20', 
                            previous==2 ~ '2018-19'),
         previous=as.factor(previous), 
         previous=fct_rev(previous)) %>% 
  filter(period>='2019-06-01') %>% 
  ggplot(., aes(x=period, y=no_calls_answered, colour=previous)) + 
  geom_line(aes(linetype=previous)) + 
  geom_point(size=2, fill='white') +
  geom_point(color='white', size=1) +
  scale_x_date(date_breaks = "2 month") + 
  scale_colour_THF(labels=c('a', 'b')) +
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.2,0.2)) +
  labs(title='Total calls answered NHS 111')

calls_offered <- two_years %>%
  mutate(previous=case_when(previous==1 ~ '2019-20', 
                            previous==2 ~ '2018-19'),
         previous=as.factor(previous), 
         previous=fct_rev(previous)) %>% 
  filter(period>='2019-06-01') %>% 
  ggplot(., aes(x=period, y=total_calls_offered, colour=previous)) + 
  geom_line(aes(linetype=previous)) + 
  geom_point(size=2, fill='white') +
  geom_point(color='white', size=1) +
  scale_x_date(date_breaks = "2 month") + 
  scale_colour_THF(labels=c('a', 'b')) +
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.2,0.4)) +
  labs(title='Total calls offered NHS 111')


calls_offered / calls_ans + 
  plot_layout(guides = "collect") & 
  theme(legend.position = 'right',
        plot.margin = unit(c(0.1,0.1,0.1,0.1), 'cm'), 
        legend.margin = margin(0.1,0.1,0.1,0.1))

ggsave(here::here('output', 'national_calls_offered_answered.png'))


ambulance <- two_years %>%
  mutate(previous=case_when(previous==1 ~ '2019-20', 
                            previous==2 ~ '2018-19'),
         previous=as.factor(previous), 
         previous=fct_rev(previous)) %>% 
  filter(period>='2019-06-01') %>% 
  ggplot(., aes(x=period, y=ambulance_dispatches, colour=previous)) + 
  geom_line(aes(linetype=previous)) + 
  geom_point(size=2, fill='white') +
  geom_point(color='white', size=1) +
  scale_x_date(date_breaks = "1 month", date_labels = '%b %Y') + 
  scale_colour_THF(labels=c('a', 'b')) +
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.2,0.3)) +
  labs(title='Ambulance dispatches')

ggsave(plot=ambulance, here::here('output', 'national_ambulance_2_years.png'))


a_and_e <- two_years %>%
  mutate(previous=case_when(previous==1 ~ '2019-20', 
                            previous==2 ~ '2018-19'),
         previous=as.factor(previous), 
         previous=fct_rev(previous)) %>% 
  filter(period>='2019-06-01') %>% 
  ggplot(., aes(x=period, y=recommended_to_attend_a_e, colour=previous)) + 
  geom_line(aes(linetype=previous)) + 
  geom_point(size=2, fill='white') +
  geom_point(color='white', size=1) +
  scale_x_date(date_breaks = "1 month", date_labels = '%b %Y') + 
  scale_colour_THF(labels=c('a', 'b')) +
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.2,0.2)) +
  labs(title='Recommended to attend A&E')

ggsave(plot=a_and_e, here::here('output', 'national_recommend_a_and_e_2_years.png'))


gp <- two_years %>%
  mutate(previous=case_when(previous==1 ~ '2019-20', 
                            previous==2 ~ '2018-19'),
         previous=as.factor(previous), 
         previous=fct_rev(previous)) %>% 
  filter(period>='2019-06-01') %>% 
  ggplot(., aes(x=period, y=recommended_to_attend_primary_care, colour=previous)) + 
  geom_line(aes(linetype=previous)) + 
  geom_point(size=2, fill='white') +
  geom_point(color='white', size=1) +
  scale_x_date(date_breaks = "1 month", date_labels = '%b %Y') + 
  scale_colour_THF(labels=c('a', 'b')) +
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.2,0.2)) +
  labs(title='Recommended to attend primary care')

ggsave(plot=gp, here::here('output', 'national_recommend_primary_care_2_years.png'))

other <- two_years %>%
  mutate(previous=case_when(previous==1 ~ '2019-20', 
                            previous==2 ~ '2018-19'),
         previous=as.factor(previous), 
         previous=fct_rev(previous)) %>% 
  filter(period>='2019-06-01') %>% 
  ggplot(., aes(x=period, y=recommended_to_attend_other_service, colour=previous)) + 
  geom_line(aes(linetype=previous)) + 
  geom_point(size=2, fill='white') +
  geom_point(color='white', size=1) +
  scale_x_date(date_breaks = "1 month", date_labels = '%b %Y') + 
  scale_colour_THF(labels=c('a', 'b')) +
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.2,0.2)) +
  labs(title='Recommended to attend other service')


ggsave(plot=other, here::here('output', 'national_recommend_other_2_years.png'))


not_other <- two_years %>%
  mutate(previous=case_when(previous==1 ~ '2019-20', 
                            previous==2 ~ '2018-19'),
         previous=as.factor(previous), 
         previous=fct_rev(previous)) %>% 
  filter(period>='2019-06-01') %>% 
  ggplot(., aes(x=period, y=not_recommended_to_attend_other_service, colour=previous)) + 
  geom_line(aes(linetype=previous)) + 
  geom_point(size=2, fill='white') +
  geom_point(color='white', size=1) +
  scale_x_date(date_breaks = "1 month", date_labels = '%b %Y') + 
  scale_colour_THF(labels=c('a', 'b')) +
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.2,0.2)) +
  labs(title='Not recommended to attend other service')


ggsave(plot=not_other, here::here('output', 'national_not_recommend_2_years.png'))


clincal_advisor <- two_years %>%
  mutate(previous=case_when(previous==1 ~ '2019-20', 
                            previous==2 ~ '2018-19'),
         previous=as.factor(previous), 
         previous=fct_rev(previous)) %>% 
  filter(period>='2019-06-01') %>% 
  ggplot(., aes(x=period, y=calls_transfered_to_clinical_advisor, colour=previous)) + 
  geom_line(aes(linetype=previous)) + 
  geom_point(size=2, fill='white') +
  geom_point(color='white', size=1) +
  scale_x_date(date_breaks = "1 month", date_labels = '%b %Y') + 
  scale_colour_THF(labels=c('a', 'b')) +
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.2,0.2)) +
  labs(title='Clinical advisor')


ggsave(plot=not_other, here::here('output', 'national_clinical_advisor_2_years.png'))

