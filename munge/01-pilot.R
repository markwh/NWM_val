# 01-pilot.R
# pilot comparison of USGS to NWM flows

## NWM output
## short-term, June 18, 00Z

st1 <- open.nc("data/ncdf/nwm.t00z.short_range.channel_rt.f004.conus.nc_georeferenced.nc")
st2 <- read.nc(st1)
st3 <- st2[-1] %>% 
  lapply(as.vector) %>% 
  data.frame()

## USGS snapshot
## June 18, 00:00:00
usgs1 <- open.nc("data/ncdf/2016-06-18_00-00-00.15min.usgsTimeSlice.ncdf")
usgs2 <- read.nc(usgs1)
usgs3 <- usgs2 %>% 
  lapply(as.vector) %>% 
  data.frame() %>% 
  mutate(stationId = trimws(stationId),
         time = ymd_hms(time))

