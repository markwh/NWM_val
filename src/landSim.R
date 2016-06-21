# Assimilation output for "land"

lnd1 <- open.nc("data/ncdf/nwm.20160526.t00z.analysis_assim.land.tm00.conus.nc_georeferenced.nc")
lnd2 <- read.nc(lnd1)
close.nc(lnd1)

str(lnd2, 1)

# Trying with fe_assim (not assim)

as1 <- open.nc("data/ncdf/nwm.20160528.t07z.fe_analysis_assim.tm00.conus.nc_georeferenced.nc")
as2 <- read.nc(as1)
close.nc(as1)

str(as2, 1)
