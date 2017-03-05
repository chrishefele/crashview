
# CrashView

## Introduction
Crashview is a project run by Code For Princeton that focuses on visualizing bicycle crash data in the Princeton area.  The code in this repository focuses on preparing the dataset -- specifically, geocoding the location information when GPS location data is not available. Because GPS-coded crash data is scarce (less than 5% of all crashes), geocoding significatnly increases the amount of data available; approximately 70% of all crash data was successfully geocoded.

This code uses the [Google geocoding API.] (https://developers.google.com/maps/documentation/geocoding/start)

## File Descriptions

###download/  (raw input data)
* bike_data1_0223.csv - Crash data that was provided for Mercer county. About 50K rows. 
* bike_data2_0447.csv - Crash data that was provided for Ocean? county. About 50K rows. 

###src/ 
* mk_all_data.sh - Script that rebuilds all the data/ files below, using the scripts below. 
* mk_crashes_GPS.R - Creates data/mercer_crashes_GPS.csv; just extracts the crashes with GPS coordinates provided. 
* mk_crashes_geocache.py - Calls the Google geocoding API for all the unique locations in the datset & stores the JSON response in data/geocache. Must run this before running mk_crashes_geocodes.py  Can be run multiple times if interrupted by network disruption, timeouts, etc. 
* mk_crashes_geocodes.py - Geocodes crash locations using the data cached by mk_crashes_geocache.py. Creates data/mercer_crashes_geocodes.csv
* rm_geocache_overquerylimit.sh - Cleans up stray cache files if exceeds Google query limit 
* mk_crashes_join_geocodes.R - Creates mercer_crashes_join_geocodes.csv  Must run mk_crashes_geocodes first. 

###data/  (output from scripts, ready for plotting or analysis)
* mercer_crashes_GPS.csv - Subset of original crash data that included GPS coordinates (about 2K rows)
* mercer_crashes_geocodes.csv - Latitude & longitude for a subset of crash data that could be successfully geocoded usin the Google geocoding API. Includes just the columns "ID", "LatitudeGeocoded" and "LongitudeGeocoded". About 36K rows. 
* mercer_crashes_join_geocodes.csv - Original dataset, with the "LatitudeGeocoded" and "LongitudeGeocoded" columns added(an inner join of the downloaded Mercer county dataset & the geocodes file above). About 36K rows.
* geocache/ - cached JSON responses from to the Google geocoding API (eliminates redundant calls). One file per location (about 17K total).  I've included an example snapshot of Mercer County location in geocache/mercer-geocache-files.tgz). File names are base-16 encoded versions of the location query sent to Google (e.g. for "Nassau Street and Washington Road, Princeton, NJ" the JSON response from the Google is saved in:  data/geocache/4E61737361752053747265657420616E642057617368696E67746F6E20526F61642C205072696E6365746F6E2C204E4A.json.  The location query string is also included in the location: field within the JSON) 

