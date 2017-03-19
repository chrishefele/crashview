
# This R script creates a file of car (not bike) crashes for the Princeton area
# There is a need to geocode an older car crash dataset, and this will be 
# accomplished by reusing this set of scripts on a new dataset 
# The car dataset has a slightly different format & column names, so 
# some columns have to be copied and/or renamed.

CAR.CRASHES.IN  <- "../../uncrash.chefele/data/crashes-local.Rda"
CAR.CRASHES.OUT <- "../download/carcrash_local.csv"

library(dplyr)

cat("Reading: ", CAR.CRASHES.IN, "\n")
df <- readRDS(CAR.CRASHES.IN)

df$MUNICIPALITY     <- df$Municipality.Name
df$CRASH_LOCATION   <- df$Crash.Location
df$CROSS_STREET_NAME<- df$Cross.Street.Name
df$LATITUDE         <- df$Latitude
df$LONGITUDE        <- df$Longitude

df$ID <- 1:nrow(df)

cat("Writing: ", CAR.CRASHES.OUT, "\n")
write.csv(df, file=CAR.CRASHES.OUT, row.names=FALSE)
cat("Done. Wrote: ", CAR.CRASHES.OUT, "\n")
