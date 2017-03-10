
# CrashView

## Introduction
Crashview is a project run by Code For Princeton that focuses on visualizing bicycle crash data from the Princeton area.  The code in this repository focuses on finding the latitude & longitude of crash locations in the cases when GPS location data was not available. Only 5% of the dataset we obtained had GPS coordinates. By using the 
[Google geocoding API.] (https://developers.google.com/maps/documentation/geocoding/start), we were able to get latitudes & longitudes for approximately 70% of the crashes, using just the address or intersection given in the crash report. 
This significantly increased the amount of data we could use for plotting and analysis with GIS tools.

## System Descriptions & Operation

The original, raw datasets are in the /download directory.  "bike_data1_0223.csv" is for Mercer county and has about 50K rows.

The output of the geocoding scripts in /src  are put in the /data directory.  

All the datasets can be rebuilt using the mk_all_data.sh script, which coordinates all the other scripts.  For geocoding, there are two steps: first, all the unique addresses/locations are extracted, and then the Google geocoding API is called for each one of them & the result is cached in /data/geocache.  Second, the cache is used to geocode all the rows in the original/raw dataset.  

Caching the API calls eliminates redundant calls, and allows the API queries to be stopped and resumed at any point.  Creating the cache is time consuming; each call takes about 1 second, when running single-threaded. So rebuilding the cache from scratch takes about 3 hours. I've included a gziped version of the cache in /data/geocache, if you'd like to pre-seed it. 

## Instructions for Use

All the datasets are already built in this repository and ready to use (in /data). But if you want to rebuild them from scratch, you would:
* Clone the respository
* gunzip /data/geocache/mercer-geocache-files.tgz (if you want to rebuild the cache)
* cd /src
* ./src/mk_all_data.sh

Note: Right now the input filename is hard coded, so that would need to be changed as well if you provided new data.

