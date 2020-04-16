library(taskscheduleR)
myscript <- here::here('R', '0_download_data.R')

runon <- format(Sys.time()+60, "%H:%M")
taskscheduler_create(taskname = "NHS111_daily", rscript = myscript,
                     schedule = "DAILY", startdate = format(Sys.Date(), "%m/%d/%Y"), 
                     starttime = runon)

## delete scheduled task, you need to do this if you want to change time/frequency
taskscheduler_delete("NHS111_daily")
