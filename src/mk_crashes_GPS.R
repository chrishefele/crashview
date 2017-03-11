
# This script extracts crash records that have GPS 
# coordinates recorded & writes only them to a .csv file.
# That file is uploaded to carto.com for plotting on a map.

INFILE   <- "../download/bike_crashes.csv" 
OUTFILE  <- "../data/mercer_crashes_GPS.csv"

cat("Reading: ", INFILE, "\n")
bike.data <- read.csv(INFILE)

print(head(bike.data))

# select just the records that have GPS coordinates recorded

has.lat.long <- !is.na(bike.data$LATITUDE)   & 
                !is.na(bike.data$LONGITUDE)  & 
                abs(bike.data$LATITUDE)  > 0 & 
                abs(bike.data$LONGITUDE) > 0 

print(head(has.lat.long))

# in carto.com, west longitude is negative 
bike.data$LONGITUDE <- (-1) * bike.data$LONGITUDE 

cat("Writing: ", OUTFILE, "\n")
write.csv( bike.data[has.lat.long, ]  ,file=OUTFILE,    row.names=FALSE)

