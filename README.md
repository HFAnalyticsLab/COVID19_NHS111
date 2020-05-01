# COVID19_NHS111


#### Project Status: In progress

## Project Description

A descriptive analysis of trends in NHS 111 activity, both all calls and related to COVID-19. NHS 111 COVID-19 actvity includes potential COVID-19 completed online assessments and potential COVID-19 triages in NHS Pathways through 111 or 999.  We are creating daily counts for England, in total and by gender and age band. 


## Data source

We are using publically available data published by NHS digital and NHS England. The data used for this analysis is not included in this repository but you can download  [COVID specific data](https://digital.nhs.uk/data-and-information/publications/statistical/mi-potential-covid-19-symptoms-reported-through-nhs-pathways-and-111-online/latest#) and [all NHS111 calls data](https://www.england.nhs.uk/statistics/statistical-work-areas/nhs-111-minimum-data-set/nhs-111-minimum-data-set-2019-20/).

No information was used that could directly identify a patient or other individual. 

The shapefiles for the CCG map can be downloaded from https://www.arcgis.com/home/item.html?id=ecac7e1b2300434499c46c62284858c2#overview

## How does it work?

The code can be used to replicate the analysis on this dataset. 

### Requirements

These scripts were written under R version 3.6.3 (2020-02-29) -- "Holding the windsock".
The following R packages (available on CRAN) are needed: 

* [**tidyverse**](https://www.tidyverse.org/)(1.3.0)
* [**janitor**](https://cran.r-project.org/web/packages/janitor/index.html) (2.0.1)
* [**lubridate**](https://cran.r-project.org/web/packages/lubridate/vignettes/lubridate.html)(1.7.8)
* [**testthat**](https://cran.r-project.org/web/packages/testthat/index.html)(2.3.2)
* [**curl**](https://cran.r-project.org/web/packages/curl/index.html)(4.3)
* [**taskscheduleR**](https://cran.r-project.org/web/packages/taskscheduleR/)(1.4) (Windows only)
* **THFstyle** internal package


Functions from internal package, theme_THF() and scale_XXX_THF() can be removed or be replaced with eg theme_minimal().  

### Getting started

The 'R' folder contains:

* 0_download_data.R - scrape links from website and use to download data.
* 1_clean_data.R - Load, clean and save cleaned data. 
* 2_NHS111_line_plots.R - Line plots of NHS 111 online assessments.
* 3_NHS111_population_pyramids.R - Population pyramid of NHS 111 online. assessments
* 4_pathways_line_plots.R - Line plots of COVID-19 triages in NHS Pathways
* 5_pathways_population_pyramids.R - Population of COVID-19 triages in NHS Pathways
* 6_NHSS111_CCG_map.R - CCG map of NHS 111 online assessments, using 2019 boundaries
* Schedule.R - Schedule daily download of data. Only works on Windows. 
* Tests.R - Unit test to check that the data has not changed. 



## Authors
* **Emma Vestesson** - [@gummifot](https://twitter.com/gummifot) - [emmavestesson](https://github.com/emmavestesson)


## License
This project is licensed under the [MIT License](https://github.com/HFAnalyticsLab/COVID19_NHS111/blob/master/LICENSE).