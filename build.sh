#!/bin/bash
set -e

mkdir -p target
cd target
curl -s --fail -L https://ratings.food.gov.uk/open-data/en-gb | grep -Eo 'http://ratings.food.gov.uk/OpenDataFiles/.*\.xml' | grep -v "cy-" | while read f; do
  printf "$f: "
  curl -w "%{http_code}" -s --fail -LO $f
  echo " done"
done
cd ..

echo "Turning into CSV"
grep -l FHRSEstablishment target/*.xml | grep -v cy- | xargs xsltproc extract_to_csv.xslt | grep -v '^[^0-9]' | grep -v '^$' | awk -F, '$9' > target/complete.csv
echo "Number of lines `wc -l target/complete.csv`"

echo "Compressing"
gzip target/complete.csv
echo "Compressing done"