
To create the pedestrian crashes:

In ../download, repoint "input_crashes.csv" symlink to the "bike_data1_0223.csv" file 

Rerun the mk_all_data.sh script in ../src
This puts 3  .csv files in ../data for all crashes (not just pedestrians)

Move the files into ../data/pedestrian_crashes

run "Rscript mk_crashes_pedestrians.R" which makes crashes_pedestrians.csv

Use the fields PEDESTRIANS_KILLED, PEDESTRIANS_INJURED, TOTAL_PEDESTRIANS_INVOLVED fields 



