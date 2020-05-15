library(curl)
library(rvest)  
library(polite)

# COVID----
# Grab links from website
link <- 'https://digital.nhs.uk/data-and-information/publications/statistical/mi-potential-covid-19-symptoms-reported-through-nhs-pathways-and-111-online/latest'
bow(link)
page <- read_html(link)
links <- page %>% html_nodes(css=".block-link") %>% html_attr('href')
titles <- page %>% html_nodes(css=".block-link") %>% html_attr('title')
named_links <- purrr::set_names(links, titles)
# NHS111 online

link_111 <- named_links['111 Online Potential COIVD-19 Open Data']

# scheduler won't run unless path is hard coded (drive mapping problem?)
destfile_111 <- here::here('data', 'original data', "NHS111_online.csv")
curl_download(link_111, destfile = destfile_111)

# Pathways

link_pathways <- named_links['NHS Pathways Potential COVID-19 Open Data']

# scheduler won't run unless path is hard coded (drive mapping problem?)
destfile_pathways <- here::here('data', 'original data',"pathways.csv")
curl_download(link_pathways, destfile = destfile_pathways)


### all NHS 111 calls
link <- 'https://www.england.nhs.uk/statistics/statistical-work-areas/nhs-111-minimum-data-set/nhs-111-minimum-data-set-2020-21/'

bow(link)
page <- read_html(link)

links_all_NHS111_csv <- page %>% 
  html_nodes(xpath = "//a[contains(text(), 'CSV')]") %>%
  html_attr('href')
# links <- page %>% html_nodes(css="#main-content > article > p:nth-child(6) > a") %>% html_attr('href')

filename_csv <- fs::path_file(links_all_NHS111_csv)

curl_download(links_all_NHS111_csv, destfile = here::here('data', 'original data',filename_csv))


links_all_NHS111_excel <- page %>% 
  html_nodes(xpath = "//a[contains(text(), 'XLSX')]") %>%
  html_attr('href')
# links <- page %>% html_nodes(css="#main-content > article > p:nth-child(6) > a") %>% html_attr('href')

filename_excel <- fs::path_file(links_all_NHS111_excel)

curl_download(links_all_NHS111_excel, destfile = here::here('data', 'original data',filename_excel))
