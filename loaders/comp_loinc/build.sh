#!/usr/bin/env bash
set -euo pipefail
# This version downloads from HOT-Ecosystem/owl-on-fhir-content and doesn't run OAK locally

cd $TIMS_DIR/loaders/comp_loinc
 

# check the input files are there
if [[ ! -e CodeSystem-CompLOINC.json ]] ; then
    wget https://github.com/HOT-Ecosystem/owl-on-fhir-content/blob/master/output/CodeSystem-CompLOINC.json?raw=true
    mv CodeSystem-CompLOINC.json?raw=true CodeSystem-CompLOINC.json
else
    echo "file found"
fi




