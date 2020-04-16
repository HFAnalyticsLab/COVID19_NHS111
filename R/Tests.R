
library(testthat)

NHS111 <- readRDS(here::here('data', 'NHS111.RDS')) %>% 
  filter(date==max(date))
pathways <- readRDS(here::here('data', 'pathways.RDS')) %>% 
  filter(date==max(date))

## NHS 111 online
test_that("All variables present; NHS 111 online",{
  expected <- c("journeydate", "sex", "ageband", "ccgcode", "ccgname", "total", "date")
  actual <- names(NHS111)
  expect_equal(expected, actual)
})

test_that("All levels presents; NHS 111 online",{
  expect_equal(c('Female', 'Male'), unique(NHS111$sex))
  expect_equal(c('0-18 years', '19-69 years', '70+ years'), unique(NHS111$ageband))
})


## pathways
test_that("All variables present; NHS pathways",{
  expected <- c("sitetype", "call_date", "sex", "ageband", "ccgcode", "ccgname", "triagecount", "date")
  actual <- names(pathways)
  expect_equal(expected, actual)
})

test_that("All levels presents; NHS 111 online",{
  expect_equal(c('Female', 'Male', 'Unknown'), unique(pathways$sex))
  expect_equal(c('0-18 years', '19-69 years', '70-120 years', NA), unique(pathways$ageband))
})


