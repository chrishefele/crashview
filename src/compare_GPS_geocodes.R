
# Script to perform a crossmatch test to determine if the 
# geographic distributions of the crashes WITH latitude & longitude 
# information provided differs from the geographic distribution 
# of the other crashes WITHOUT latitude & longitude recorded 
#
# The crashes without that information need to be geocoded to 
# determine their latitude/longitude. But is there some bias that  
# determines which crashes have GPS coordinates recorded, and which do not?
#
# Results indicate that yes, the distributions seem different. 
# Interpretation/investigation  of this is TBD. 
#

library(geosphere)
library(crossmatch)

# sample to same memory / computation time 
NSAMPLES_GEO <- 3000
NSAMPLES_GPS <- 2800

GEOCODES_FILE   <- "../data/mercer_crashes_geocodes.csv"
GPS_FILE        <- "../data/mercer_crashes_GPS.csv"

cat('reading:', GEOCODES_FILE, '\n')
df.geo <- read.csv(GEOCODES_FILE)
cat('reading:', GPS_FILE, '\n')
df.gps <- read.csv(GPS_FILE)

latlng.geo <- as.matrix(data.frame( longitude=df.geo$LongitudeGeocoded,
                                    latitude =df.geo$LatitudeGeocoded ))

latlng.gps <- as.matrix(data.frame( longitude=df.gps$LONGITUDE,
                                    latitude =df.gps$LATITUDE))

latlng.geo <- latlng.geo[ sample(1:nrow(latlng.geo), NSAMPLES_GEO), ]
latlng.gps <- latlng.gps[ sample(1:nrow(latlng.gps), NSAMPLES_GPS), ]

latlng          <- rbind(latlng.geo, latlng.gps)
latlng.labels   <- c(rep(0, nrow(latlng.geo)), 
                     rep(1, nrow(latlng.gps)))

cat('calculating distance matrix\n')
latlng.dist.matrix <- distm(latlng) # great circle dist between all crash locations 

cat('calculating crossmatch test\n')
crossmatch.result <- crossmatchtest(latlng.labels, latlng.dist.matrix)

cat('crossmatch test result\n')
print(crossmatch.result)

