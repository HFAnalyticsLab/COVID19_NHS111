library(THFstyle)
library(tidyverse)

all_NHS_111 <-readRDS(here::here('data', 'all_NHS_111'))
THF_red <- '#dd0031'

  
regional <- all_NHS_111 %>% 
  mutate(period=lubridate::date(period)) %>% 
  filter(period> '2019-04-01') %>% 
  mutate_at(vars(-c(concat, region, provider, period,  code, area )), as.numeric) %>% 
  group_by(period, region ) %>% 
  summarise_if(is.numeric, sum)

regional2 <- regional %>% 
  mutate_at(vars(starts_with('recommended')), list(p=~.x/no_calls_answered ))

latest <-   regional %>% 
  filter(period>'2020-04-01')

last_year <-   regional %>% 
  filter(period=='2019-04-30')

ggplot(regional, aes(x=period, y=no_calls_answered, group=region)) + 
         geom_line(aes(colour=region) )+ 
         geom_point(aes(colour=region), size=2, fill='white') +
         geom_point(color='white', size=1) + scale_colour_THF() +
         scale_x_date(date_breaks = "2 month") + 
         theme_THF() +
         scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
         theme(plot.title = element_text(hjust = 0 ),         
               plot.title.position='plot', legend.position = c(0.8,0.5)) +
         labs(caption='Source: NHS England', 
              title='Calls offered')

regional %>% 
  ggplot(., aes(x=period, y=no_of_abandoned_calls, group=region)) + 
  geom_line(aes(colour=region) )+ 
  geom_point(aes(colour=region), size=2, fill='white') +
  geom_point(color='white', size=1) + scale_colour_THF() +
  scale_x_date(date_breaks = "2 month") + 
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.2,0.2)) +
  labs(caption='Source: NHS England', 
       title='Calls offered')

plots <- c('no_calls_answered', "calls_transfered_to_clinical_advisor" )


regional2 %>% 
  ggplot(., aes(x=period, y=ambulance_dispatches, group=region)) + 
  geom_line(aes(colour=region) )+ 
  geom_point(aes(colour=region), size=2, fill='white') +
  geom_point(color='white', size=1) + scale_colour_THF() +
  scale_x_date(date_breaks = "2 month") + 
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.2,0.2)) +
  labs(caption='Source: NHS England', 
       title='Ambulance dispatches')

regional2 %>% 
  ggplot(., aes(x=period, y=calls_answered_within_60_secs_calls_ans_p, group=region)) + 
  geom_line(aes(colour=region) )+ 
  geom_point(aes(colour=region), size=2, fill='white') +
  geom_point(color='white', size=1) + scale_colour_THF() +
  scale_x_date(date_breaks = "2 month") + 
  theme_THF() +
  scale_y_continuous(limits = c(0, NA), labels = scales::comma) + scale_fill_THF() + ylab('') + xlab('') +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.2,0.2)) +
  labs(caption='Source: NHS England', 
       title='Calls answered within 60 seconds')

# Automating plots
population_denom <- c("total_calls_offered", "no_of_abandoned_calls", "no_calls_answered", "calls_answered_within_60_secs", "no_calls_triaged", "calls_transfered_to_clinical_advisor", "warm_transfered_to_clinical_advisor", "person_offered_call_back", "calls_back_within_10_min", "calls_to_a_clinician", "ambulance_dispatches", "recommended_to_attend_a_e", "recommended_to_attend_primary_care", "recommended_to_contact_primary_care", "recommended_to_speak_to_primary_care", "recommended_to_dental_pharmacy", "recommended_to_dental", "recommended_to_pharmacy", "recommended_to_attend_other_service", "not_recommended_to_attend_other_service", "given_health_information", "recommended_home_care", "recommended_non_clinical")
calls_answered_denom <- c( "no_calls_answered", "calls_answered_within_60_secs", "no_calls_triaged", "calls_transfered_to_clinical_advisor", "warm_transfered_to_clinical_advisor", "person_offered_call_back", "calls_back_within_10_min", "calls_to_a_clinician", "ambulance_dispatches", "recommended_to_attend_a_e", "recommended_to_attend_primary_care", "recommended_to_contact_primary_care", "recommended_to_speak_to_primary_care", "recommended_to_dental_pharmacy", "recommended_to_dental", "recommended_to_pharmacy", "recommended_to_attend_other_service", "not_recommended_to_attend_other_service", "given_health_information", "recommended_home_care", "recommended_non_clinical")


regional2 <- regional %>% 
  mutate_at(calls_answered_denom, list(calls_ans_p=~.x/no_calls_answered )) %>% 
  mutate_at(population_denom, list(pop_p=~.x/population )) 

thf_plot <-  function(x) {  
  ggplot(regional2, aes(x=period, y=.data[[x]], group=region)) + 
  geom_line(aes(colour=region) )+ 
  geom_point(aes(colour=region), size=2, fill='white') +
  geom_point(color='white', size=1) + scale_colour_THF() +
  scale_x_date(date_breaks = "2 month") + 
  theme_THF() +
    scale_fill_THF() + ylab('') + xlab('')  +
  theme(plot.title = element_text(hjust = 0 ),         
        plot.title.position='plot', legend.position = c(0.2,0.2)) +
  labs(caption='Source: NHS England', 
       title=paste(x)) }



plot_list <- map(calls_answered_denom, ~thf_plot(.) ) %>% 
  set_names(calls_answered_denom)

map2(plot_list, paste0(names(plot_list), '.png'), ~ggsave(plot=.x, .y))
  
paste0(names(plot_list), '.png')
