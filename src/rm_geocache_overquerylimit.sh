
# This script removes geocache files that contain no useful information.
# These files were created by mk-crashes-geocoded.py 
# after it hit the Google API query limit (because of an API key issue).
# After this script is run, rerun mk-crashes-geocoded.py 
# so the removed files will be properly repopulated.

cd ../data/geocache

grep OVER_QUERY_LIMIT *.json | awk '{print $1}' | sed 's/://g' > over-query-limit-files

for f in `cat over-query-limit-files`
do
    rm --verbose $f
done

rm over-query-limit-files


