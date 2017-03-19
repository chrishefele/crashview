
# This script does an inner join between the original
# crash records and the crashes that were successfully 
# geocoded (about 70% of total).
# The resulting .csv file can be uploaded to carto.com 
# for plotting on a map.

LEFT_FILE  <- "../download/input_crashes.csv" 
RIGHT_FILE <- "../data/crashes_geocodes.csv"
JOIN_FILE  <- "../data/crashes_join_geocodes.csv"

cat("Reading: ", LEFT_FILE, "\n")
df.left  <- read.csv(LEFT_FILE)
# in carto.com, west longitude is negative 
df.left$LONGITUDE <- (-1) * df.left$LONGITUDE 

cat("Reading: ", RIGHT_FILE, "\n")
df.right <- read.csv(RIGHT_FILE)

df.join <- merge(df.left, df.right, by="ID")

cat("Writing: ", JOIN_FILE, "\n")
write.csv(df.join, file=JOIN_FILE, row.names=FALSE)
cat("Done. Wrote: ", JOIN_FILE, "\n")

