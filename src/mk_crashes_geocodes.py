
# mk_crashes_geocodes.py
#
# This script writes a file with the GPS coordinates of each crash,
# given in the crash data (read by the function crash_iter()).
# Those coordinates are derived by geocoding the address / location fields
# using data retrieved & cached from the Google geocoding API.
# Therefore, the script mk_crashes_geocache must be run before this script,
# 

import os.path
import sys
import json
import csv
from   mk_crashes_geocache import crashes_iter, crash_geoquery, \
                                  geoquery_cachefile, is_accurate

CRASHES_GEOCODED_CSV = '../data/crashes_geocodes.csv'
DEBUG = True


def write_crashes_geocodes_file(outfile):

    print "Writing geocodes crash file:", outfile
    with open(outfile,'w') as csvfile:

        fieldnames = ['ID', 'LatitudeGeocoded', 'LongitudeGeocoded']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

        for crash_n, crash in enumerate(crashes_iter()):

            geoquery    = crash_geoquery(crash)
            cache_file  = geoquery_cachefile(geoquery)

            if not os.path.isfile(cache_file): 
                if DEBUG:
                    print crash_n, "SKIPPED (No cache file) Query:", geoquery
                continue

            with open(cache_file) as json_file:  
                g_json = json.load(json_file)
            if not is_accurate(g_json):
                if DEBUG:
                    print crash_n, "SKIPPED (Location not accurate) Query:", geoquery
                continue

            lat, lng = g_json['lat'], g_json['lng']  
            # pedalcyclist_flag = 1*(crash.CRASH_TYPE == "Pedalcyclist")

            outfields = { 'ID':crash.ID, 'LatitudeGeocoded':lat, 'LongitudeGeocoded':lng }
            writer.writerow(outfields)

            if DEBUG:
                print crash_n, "WROTE:", outfields

    print "Finished writing crash file:", outfile

if __name__ == "__main__":
    write_crashes_geocodes_file(CRASHES_GEOCODED_CSV)

