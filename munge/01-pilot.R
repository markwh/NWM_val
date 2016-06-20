# 01-pilot.R
# pilot comparison of USGS to NWM flows

## NWM output
## short-term, June 18, 00Z

st1 <- open.nc("data/ncdf/nwm.t00z.short_range.channel_rt.f004.conus.nc_georeferenced.nc")
st2 <- read.nc(st1)
close.nc(st1)
st3 <- st2[-1] %>% 
  lapply(as.vector) %>% 
  data.frame() %>% 
  mutate(reach = as.character(station_id))

## USGS snapshot
## June 18, 00:00:00
usgs1 <- open.nc("data/ncdf/2016-06-18_00-00-00.15min.usgsTimeSlice.ncdf")
usgs2 <- read.nc(usgs1)
close.nc(usgs1)
usgs3 <- usgs2 %>% 
  lapply(as.vector) %>% 
  data.frame() %>% 
  mutate(stationId = trimws(stationId),
         time = ymd_hms(time))

## Assimilation
## June 18, 00Z
as1 <- st1 <- open.nc("data/ncdf/nwm.20160618.t00z.analysis_assim.channel_rt.tm00.conus.nc_georeferenced.nc")
as2 <- read.nc(as1)
close.nc(as1)
as3 <- as2[-1] %>% 
  lapply(as.vector) %>% 
  data.frame()


## Joining datasets

gageinfo <- read.csv("data/gageloc/GageLoc.csv", colClasses = "character") %>% 
  transmute(reach = FLComID.N.9.0, stationId = SOURCE_FEA.C.40)

usgs4 <- usgs3 %>% 
  left_join(gageinfo, by = "stationId")

dat1 <- usgs4 %>% 
  left_join(st3, by = "reach")

cache("dat1") # joined short-term forecast and observation.


