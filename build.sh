#!/bin/bash
set -ex

mkdir target
cd target
curl -s --fail -L https://ratings.food.gov.uk/open-data/en-gb | grep -Eo 'http://ratings.food.gov.uk/OpenDataFiles/.*\.xml' | grep -v "cy-" | xargs -P1 -n1 -I{} curl -w "{} %{http_code}, " -s --fail -LO {}
cd ..

grep -l FHRSEstablishment target/*.xml | grep -v cy- | xargs xsltproc extract_to_csv.xslt | grep -v '^[^0-9]' | grep -v '^$' | awk -F, '$9' > target/complete.csv

gzip target/complete.csv
