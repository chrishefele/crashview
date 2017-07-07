
# generate a file with just crashes involving pedestrians

OUTFILE <- "crashes_pedestrians.csv"

crashes <- read.csv("crashes_join_geocodes.csv")

with.pedestrians <- crashes$TOTAL_PEDESTRIANS_INVOLVED > 0
write.csv( crashes[with.pedestrians,], file=OUTFILE, row.names=FALSE)


