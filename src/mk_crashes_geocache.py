
# mk_crashes_geocache.py
# 
# This code determines the latitude and longitude of the crash locations 
# that appear in the crash dataset. It caches those locations (& other info
# in a json) for future use by other scripts. 
#
# Many crash locations appear multiple times in the dataset, so
# this caching reduces the calls to the Google geocoding API by 70%.
# For the 50K row dataset, caching reduces queries to 17K.
# Runtime for the 17K API calls is about 3 hours. 
#
# For more information about the Google geocoding API, see:
#  https://developers.google.com/maps/documentation/geocoding/start
#
# When using that API for more than 2500 queries/day,
# you need an API key (so Google can bill for usage via credit-card)
# After getting an API key (see the "Get a Key" section in the URL above)
# You can make it available to the script using:
# $ export GOOGLE_API_KEY=<Secret API Key>
# before running this script.


import geocoder
import pandas
from   base64 import b16encode, b16decode
import os.path
import json
from   collections import OrderedDict


CRASH_FILE   = "../download/input_crashes.csv"
GEOCACHE_DIR = "../data/geocache/"
VERBOSE      = False


def crashes_iter():
    print "reading:", CRASH_FILE
    crashes = pandas.read_csv(CRASH_FILE)
    # null strings by default are read as NaN, so convert to ''
    for col in ['CRASH_LOCATION', 'CROSS_STREET_NAME', 'MUNICIPALITY']:
        crashes[col] = crashes[col].fillna('')
    for index, crash in crashes.iterrows():
        yield crash

def crash_geoquery(crash):
    # create a crash location/address from the fields in the crash record
    location     = crash.CRASH_LOCATION.strip()
    cross_street = crash.CROSS_STREET_NAME.strip()
    municipality = crash.MUNICIPALITY.strip()
    # available but unused fields: "INTERSECTION", "MILEPOST"
    if cross_street:
        geoquery = "%s and %s, %s, NJ" % (location, cross_street, municipality)
    else:
        geoquery = "%s, %s, NJ"        % (location,               municipality)
    return geoquery

def geoquery_cachefile(geoquery):
    # File in which to store the json results returned by the geolocation API call
    # The file name is just an encoded version of the location string (geoquery)
    cache_file = GEOCACHE_DIR + b16encode(geoquery) + '.json'
    return cache_file

def is_accurate(g_json):
    # return an assessment of whether or not the returned latitude/longitude 
    # is accurate enough to use for mapping, based on confidence estimates 
    # and other parameters returned by the Google geolocation API
    return  g_json['status'] == "OK" and \
            g_json['confidence'] >= 9 and \
            g_json['accuracy'] in ['ROOFTOP', 'APPROXIMATE', 'RANGE_INTERPOLATED']

def print_json_fields(g_json, header_fields=None):
        print "-----------------------------------------"
        for field in header_fields:
            print "%-12s : %s" % (field, header_fields[field])
        for field in sorted(g_json):
            print "%-12s : %s" % (field, g_json[field])

def make_geoquery_cache():

    for crash_n, crash in enumerate(crashes_iter()):

        geoquery   = crash_geoquery(crash)
        cache_file = geoquery_cachefile(geoquery)
        
        # if info about the crash location is not in the cache,
        # call the Google geocoding API and save the JSON result
        if not os.path.isfile(cache_file): 
            g = geocoder.google(geoquery)
            g_json = g.json
            called_API = True
            with open(cache_file, 'w') as outfile:  
                json.dump(g_json, outfile, sort_keys=True, indent=4)
        else:
            with open(cache_file) as infile:  
                g_json = json.load(infile)
            called_API = False

        if VERBOSE:
            header_fields = OrderedDict()
            header_fields['crash_num'  ] = crash_n
            header_fields['geoquery'   ] = geoquery
            header_fields['called_API' ] = called_API
            header_fields['cache_file' ] = cache_file
            header_fields['is_accurate'] = is_accurate(g_json)
            print_json_fields(g_json, header_fields)
        else:
            print crash_n, geoquery
       

if __name__ == "__main__":

    make_geoquery_cache()



