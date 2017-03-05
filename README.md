
# CrashView

## Introduction
Crashview is a project run by Code For Princeton that focuses on visualizing bicycle crash data in the Princeton area.  The code in this repository focuses on preparing the dataset -- specifically, geocoding the location information when GPS location data is not available. Because GPS-coded crash data is scarce (less than 5% of all crashes), geocoding significatnly increases the amount of data available; approximately 70% of all crash data was successfully geocoded.

This code uses the [Google geocoding API.] (https://developers.google.com/maps/documentation/geocoding/start)

## File Descriptions

###download/
* bike_data1_0223.csv - Crash data that was provided for Mercer county. About 50K rows. 
* bike_data2_0447.csv - Crash data that was provided for Ocean? county. About 50K rows. 

###data/
* mercer_crashes_GPS.csv - Subset of original crash data that included GPS coordinates (about 2K rows)
* mercer_crashes_geocodes.csv - Latitude & longitude for a subset of crash data that could be successfully geocoded usin the Google geocoding API. Includes just the columns "ID", "LatitudeGeocoded" and "LongitudeGeocoded". About 36K rows. 
* mercer_crashes_join_geocodes.csv - Original dataset, with the "LatitudeGeocoded" and "LongitudeGeocoded" columns added(an inner join of the above 2 files). About 36K rows.
* geocache/ - cached JSON responses from to the Google geocoding API (eliminates redundant calls). One file per location (about 17K total). File names are base-16 encoded versions of the location string (e.g. "Nassau Street and Washington Road, Princeton, NJ")
###src/
* mk_all_data.sh - Script that coordinates rebuilding all the datafiles above 
* mk_crashes_GPS.R - Creates data/mercer_crashes_GPS.csv
* mk_crashes_geocache.py - Calls the Google geocoding API for all the unique locations in the datset & stores the JSON response in data/geocache. 
* mk_crashes_geocodes.py - Creates data/mercer_crashes_geocodes.csv
* rm_geocache_overquerylimit.sh - Cleans up stray cache files if exceeds Google query limit 
* mk_crashes_join_geocodes.R - Creates mercer_crashes_join_geocodes.csv

