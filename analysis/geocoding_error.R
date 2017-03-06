
library(geosphere)

GEOCODES_FILE   <- "../data/mercer_crashes_join_geocodes.csv"

cat('reading:', GEOCODES_FILE, '\n')
df <- read.csv(GEOCODES_FILE)

has.gps <- abs(df$LATITUDE)>0 & abs(df$LONGITUDE)>0
df <- df[has.gps,]

# so now the rows in df have both GPS coordinates & geocoded coordinates
# Let's compare them!

latlng.geo <- as.matrix(data.frame( longitude=df$LongitudeGeocoded, latitude =df$LatitudeGeocoded ))
latlng.gps <- as.matrix(data.frame( longitude=df$LONGITUDE, latitude =df$LATITUDE))

geocoding.err <- distHaversine(latlng.geo, latlng.gps) # by default, error units are meters

pdf(file="geocoding_error.pdf")
hist(log10(geocoding.err), main="Geocoding Error (log10_meters)" )

cat("median geocoding error:", median(geocoding.err),' meters\n')
cat("mean   geocoding error:", mean(geocoding.err),' meters\n')
cat("min    geocoding error:", min(geocoding.err),' meters\n')
cat("max    geocoding error:", max(geocoding.err),' meters\n')

