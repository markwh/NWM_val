## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

library(ProjectTemplate)
load.project()

## ------------------------------------------------------------------------
reaches <- read.csv("data/pilot/reaches.csv", stringsAsFactors = FALSE) %>% 
  mutate(gage = sprintf("%08i", Gage.no.))
  
gages <- unique(reaches$gage[!grepl("NA", reaches$gage)])

## ------------------------------------------------------------------------
dataRetrieval::pCodeToName %>% 
  filter(grepl("height", description, ignore.case = TRUE) |
           grepl("stage", description, ignore.case = TRUE))

stageParams <- c("00065", "00072", "30207", "99065")
flowParams <- c("00059", "00060", "00061")

dataRetrieval::pCodeToName %>% 
  filter(grepl("flow", description, ignore.case = TRUE) |
           grepl("discharge", description, ignore.case = TRUE))



testStage <- readNWISuv(siteNumbers = gages[1:2], 
                        parameterCd = stageParams,
                        startDate = "2016-01-01", endDate = "2016-02-01")

testFlow <- readNWISuv(siteNumbers = gages[1:2], 
                        parameterCd = flowParams,
                        startDate = "2016-01-01", endDate = "2016-02-01")

glimpse(testStage)
glimpse(testFlow)



## ------------------------------------------------------------------------

flows12 <- readNWISuv(siteNumbers = gages, 
                        parameterCd = flowParams,
                        startDate = "2012-01-01", endDate = "2012-12-31")
pryr::object_size(flows12) # 11 MB per year? No big deal!

flows13 <- readNWISuv(siteNumbers = gages, 
                        parameterCd = flowParams,
                        startDate = "2013-01-01", endDate = "2013-12-31")

flows14 <- readNWISuv(siteNumbers = gages, 
                        parameterCd = flowParams,
                        startDate = "2014-01-01", endDate = "2014-12-31")

flows15 <- readNWISuv(siteNumbers = gages, 
                        parameterCd = flowParams,
                        startDate = "2015-01-01", endDate = "2015-12-31")

flows16 <- readNWISuv(siteNumbers = gages, 
                        parameterCd = flowParams,
                        startDate = "2016-01-01", endDate = "2016-06-18")


## ------------------------------------------------------------------------
stages12 <- readNWISuv(siteNumbers = gages, 
                        parameterCd = stageParams,
                        startDate = "2012-01-01", endDate = "2012-12-31")

stages13 <- readNWISuv(siteNumbers = gages, 
                        parameterCd = stageParams,
                        startDate = "2013-01-01", endDate = "2013-12-31")

stages14 <- readNWISuv(siteNumbers = gages, 
                        parameterCd = stageParams,
                        startDate = "2014-01-01", endDate = "2014-12-31")

stages15 <- readNWISuv(siteNumbers = gages, 
                        parameterCd = stageParams,
                        startDate = "2015-01-01", endDate = "2015-12-31")

stages16 <- readNWISuv(siteNumbers = gages, 
                        parameterCd = stageParams,
                        startDate = "2016-01-01", endDate = "2016-06-18")


## ------------------------------------------------------------------------
cache("flows12")
cache("flows13")
cache("flows14")
cache("flows15")
cache("flows16")

## ------------------------------------------------------------------------
cache("stages12")
cache("stages13")
cache("stages14")
cache("stages15")
cache("stages16")

## ------------------------------------------------------------------------
hourlyFlow <- function(df) {
  out <- df %>% 
    mutate(dt_hour = format(dateTime, "%Y%m%d%H")) %>% 
    group_by(site_no, dt_hour) %>% 
    summarize(flow_cfs = median(X_00060_00011),
              afrac = sum(X_00060_00011_cd == "A") / n(),
              tz = unique(tz_cd))
}

hourlyStage <- function(df) {
  out <- df %>% 
    mutate(dt_hour = format(dateTime, "%Y%m%d%H")) %>% 
    group_by(site_no, dt_hour) %>% 
    summarize(stage_ft = median(X_00065_00011),
              afrac = sum(X_00065_00011_cd == "A") / n(),
              tz = unique(tz_cd))
}

## ------------------------------------------------------------------------
flows12_ag <- hourlyFlow(flows12)
flows13_ag <- hourlyFlow(flows13)
flows14_ag <- hourlyFlow(flows14)
flows15_ag <- hourlyFlow(flows15)
flows16_ag <- hourlyFlow(flows16)

## ------------------------------------------------------------------------
stages12_ag <- hourlyStage(stages12)
stages13_ag <- hourlyStage(stages13)
stages14_ag <- hourlyStage(stages14)
stages15_ag <- hourlyStage(stages15)
stages16_ag <- hourlyStage(stages16)

## ------------------------------------------------------------------------
cache("flows12_ag")
cache("flows13_ag")
cache("flows14_ag")
cache("flows15_ag")
cache("flows16_ag")

## ------------------------------------------------------------------------
cache("stages12_ag")
cache("stages13_ag")
cache("stages14_ag")
cache("stages15_ag")
cache("stages16_ag")

