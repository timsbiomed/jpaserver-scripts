#!/usr/bin/env bash
set -euo pipefail
source venv/bin/activate

# assumes corresponding install_release.sh local to loaders/comp_loinc  has been run 

cd $TIMS_DIR/loaders/comp_loinc

# check the input files are there
if [[ ! -e merged_reasoned_loinc.owl ]] ; then
    wget https://github.com/loinc/comp-loinc/blob/main/data/output/merged_reasoned_loinc.owl?raw=true
    mv merged_reasoned_loinc.owl?raw=true merged_reasoned_loinc.owl
else
    echo "file found"
fi

# CONVERT to FHIR
runoak -i merged_reasoned_loinc.owl dump -o CodeSystem-CompLOINC.json -O fhirJson --include-all-predicates 2> oak.err > oak.log 
if [[ $? ]] ; then
    echo "OAK is done"
else
    echo "ERROR, OAK seems to have had errors"
    exit 1
fi



