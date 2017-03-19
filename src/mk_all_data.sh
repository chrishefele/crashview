
Rscript mk_crashes_GPS.R | tee ../logs/mk_crashes_GPS.log 

./rm_geocache_overquerylimit.sh

# export GOOGLE_API_KEY=<your Google API key>
# ...or...use a script to set your API key, e.g. 
source set_google_API_key.sh

stdbuf -o0 python mk_crashes_geocache.py | tee ../logs/mk_crashes_geocache.log

stdbuf -o0 python mk_crashes_geocodes.py | tee ../logs/mk_crashes_geocodes.log 

stdbuf -o0 Rscript mk_crashes_join_geocodes.R | tee ../logs/mk_crashes_join_geocodes.log

