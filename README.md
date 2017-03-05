
# CrashView

## Introduction
Crashview is a project run by Code For Princeton that focuses on visualizing the location of bicycle crashes in the Princeton area.  The code in this repository focuses on preparing the dataset -- specifically, geocoding the location information when GPS location data is not available -- to allow it to be easily mapped with GIS tools.

This code uses the [Google geocoding API.] (https://developers.google.com/maps/documentation/geocoding/start)

## File Descriptions

* ./download/bike_data1_0223.csv - Crash data that was provided for Mercer county. About 50K rows. 
* ./download/bike_data2_0447.csv - Crash data that was provided for Ocean? county. About 50K rows. 

* ./data/mercer_crashes_GPS.csv - Subset of original crash data that included GPS coordinates (about 2K rows)
* ./data/mercer_crashes_geocodes.csv - Latitude & longitude for a subset of crash data that could be successfully geocoded usin the Google geocoding API. Includes just the columns "ID", "LatitudeGeocoded" and "LongitudeGeocoded". About 36K rows. 
* ./data/mercer_crashes_join_geocodes.csv - Original dataset, with the "LatitudeGeocoded" and "LongitudeGeocoded" columns added(an inner join of the above 2 files). About 36K rows.
* ./data/geocache/ - cached JSON responses from to the Google geocoding API (eliminates redundant calls). One file per location (about 17K total). File names are base-16 encoded versions of the location string (e.g. "Nassau Street and Washington Road, Princeton, NJ")

* ./src/mk_all_data.sh - Script that coordinates rebuilding all the datafiles above 
* ./src/mk_crashes_GPS.R - Creates data/mercer_crashes_GPS.csv
* ./src/mk_crashes_geocache.py - Calls the Google geocoding API for all the unique locations in the datset & stores the JSON response in data/geocache. 
* ./src/mk_crashes_geocodes.py - Creates data/mercer_crashes_geocodes.csv
* ./src/rm_geocache_overquerylimit.sh - Cleans up stray cache files if exceeds Google query limit 
* ./src/mk_crashes_join_geocodes.R - Creates mercer_crashes_join_geocodes.csv

* ./logs - logfiles of the runs of the various scripts 

