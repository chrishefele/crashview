
# CrashView

## Introduction
Crashview is a project run by Code For Princeton that focuses on visualizing bicycle crash data from the Princeton area.  The code in this repository focuses on finding the latitude & longitude of crash locations in the cases when GPS location data was not available. Only 5% of the dataset we obtained had GPS coordinates. By using the 
[Google geocoding API.] (https://developers.google.com/maps/documentation/geocoding/start), we were able to get latitudes & longitudes for approximately 70% of the crashes, using just the address or intersection given in the crash report. 
This significantly increased the amount of data we could use for plotting and analysis with GIS tools.

## System Descriptions & Operation

The original, raw datasets are in the /download directory.  bike_crashes.csv is a symbolic link to an appropriate input dataset. 

The output of the geocoding scripts put in the /data directory.  

All the datasets can be rebuilt using the /src/mk_all_data.sh script, which coordinates all the other scripts.  

For geocoding, all the results from the Google geocoding API calls are cached in files in /data/geocache.This eliminate redundant calls, or repeated calls when other scripts using the API data are re-run.  Creating the cache is time consuming, though. Each API takes about 1 second (single threaded), so geocoding the original dataset took about 3 hours. I've included a gziped version of the cache in /data/geocache, if you'd like to pre-seed the cache.  

Runtime of all the other scripts is < 1 minute.  

## Instructions for Use

All the datasets are already built in this repository and ready to use (in /data). But if you want to rebuild them from scratch, you would:
* Clone the respository
* cd /data/geocache; tar -xvzf mercer-geocache-files.tgz (but only if you want to pre-seed the cache)
* cd /src
* ./src/mk_all_data.sh

Note: Right now the input filename is hard coded in the scripts as bike_crashes.csv, which is a symbolic link in /download which now points to the file of interest.  So that link would need to be changed if you provided new data. 

