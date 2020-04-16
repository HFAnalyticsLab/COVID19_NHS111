library(curl)

# NHS111 online

link_111 <- paste0(
  "https://files.digital.nhs.uk/59/067AE3/111%20Online%20Covid-19%20data_",
  lubridate::today() - 1, ".csv"
)

# scheduler won't run unless path is hard coded (drive mapping problem?)
destfile_111 <- "M:/COVID-19/COVID19_NHS111/data/original data/NHS111_online.csv"
curl_download(link_111, destfile = destfile_111)

# Pathways

link_pathways <- paste0(
  "https://files.digital.nhs.uk/A6/FFFE0E/NHS%20Pathways%20Covid-19%20data%20",
  lubridate::today() - 1, ".csv"
)


# scheduler won't run unless path is hard coded (drive mapping problem?)
destfile_pathways <- "M:/COVID-19/COVID19_NHS111/data/original data/pathways.csv"
curl_download(link_pathways, destfile = destfile_pathways)
