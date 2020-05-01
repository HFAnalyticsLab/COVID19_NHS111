library(readxl)
library(tidyverse)

all_NHS_111 <- read_excel(here::here('data','Original data', "20200409-NHS-111-MDS-time-series-to-March-2020-1.xlsx"), 
                                                                sheet = "Raw", skip = 4)
old_names <- names(all_NHS_111)
all_NHS_111 <- all_NHS_111 %>% 
  janitor::row_to_names(row_number = 1)
new_names <- names(all_NHS_111)
perfect_names <- coalesce(new_names, old_names)
names(all_NHS_111) <- perfect_names
all_NHS_111 <- all_NHS_111 %>% 
  janitor::clean_names() %>% 
  select(c(1:30))


saveRDS(all_NHS_111, here::here('data', 'all_NHS_111'))