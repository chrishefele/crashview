
# This script analyzes the geocoding error for bicycle crashes in the dataset
# When a GPS lat/long was recorded for the bicycle crash, it compares those
# coordinates against the lat/long derived from geocoding using 
# the crash address/intersection information.

library(geosphere)

GEOCODES_FILE   <- "../data/mercer_crashes_join_geocodes.csv"

cat('reading:', GEOCODES_FILE, '\n')
df <- read.csv(GEOCODES_FILE)

has.gps <- abs(df$LATITUDE)>0 & abs(df$LONGITUDE)>0
df <- df[has.gps,]

df <- df[df$CRASH_TYPE == 'Pedalcyclist',] # use just bicycle accidents

# so now the rows in df have both GPS coordinates & geocoded coordinates
# Let's compare them!

latlng.geo <- as.matrix(data.frame( longitude=df$LongitudeGeocoded, latitude =df$LatitudeGeocoded ))
latlng.gps <- as.matrix(data.frame( longitude=df$LONGITUDE, latitude =df$LATITUDE))

geocoding.err <- distHaversine(latlng.geo, latlng.gps) # by default, error units are meters

df$GeocodingError <- geocoding.err

pdf(file="geocoding_error.pdf")
hist(log10(geocoding.err), main="Geocoding Error (log10_meters)" )

cat("median geocoding error:", median(geocoding.err),' meters\n')
cat("mean   geocoding error:", mean(geocoding.err),' meters\n')
cat("min    geocoding error:", min(geocoding.err),' meters\n')
cat("max    geocoding error:", max(geocoding.err),' meters\n')

# sort the locations by difference between GPS & geolocated location
df2 <- df[,c('CRASH_LOCATION','CROSS_STREET_NAME','GeocodingError')]
df2 <- df2[order(df2$GeocodingError),]
df2$addr <- paste(df2$CRASH_LOCATION, df2$CROSS_STREET_NAME, df2$MUNICIPALITY, sep="+")
df3 <- df2[,c('GeocodingError', 'addr')]
print(df3)



