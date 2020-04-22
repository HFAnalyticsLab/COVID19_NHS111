library(curl)

# NHS111 online

link_111 <- 'https://files.digital.nhs.uk/9A/7B6495/111%20Online%20Covid-19%20data_2020-04-21.csv'


# scheduler won't run unless path is hard coded (drive mapping problem?)
destfile_111 <- "M:/COVID-19/COVID19_NHS111/data/original data/NHS111_online.csv"
curl_download(link_111, destfile = destfile_111)

# Pathways

link_pathways <- 'https://files.digital.nhs.uk/82/AE4DE7/NHS%20Pathways%20Covid-19%20data%202020-04-21.csv'

# scheduler won't run unless path is hard coded (drive mapping problem?)
destfile_pathways <- "M:/COVID-19/COVID19_NHS111/data/original data/pathways.csv"
curl_download(link_pathways, destfile = destfile_pathways)
