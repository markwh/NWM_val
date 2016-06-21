# helpers.R

getShortTerm <- function(date, hour, lead, file, 
                         download = TRUE,quiet = FALSE) {
  date <- format(as.Date(date), format = "%Y%m%d")
  stopifnot(hour >= 0 && hour <= 23)
  stopifnot(lead >= 1 && lead <= 15)
  
  hour <- sprintf("%02g", hour)
  lead <- sprintf("%03g", lead)
  
  fil <- sprintf("short_range-%s-nwm.t%sz.short_range.channel_rt.f%s.conus.nc_georeferenced.nc",
                 date, hour, lead)
  url <- paste0("https://apps.hydroshare.org/apps/nwm-data-explorer/api/GetFile?file=",
                fil)
  
  if (download)
    download.file(url, destfile = file, method = "wget", extra = "--no-check-certificate")
  invisible(url)
}

# foo <- getShortTerm(date = "2016-06-18", hour = 0, lead = 5, file = "data/test.nc")
