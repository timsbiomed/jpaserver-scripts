#!/usr/bin/env bash
set -euo pipefail

# assumes corresponding install_dev.sh local to loaders/comp_loinc  has been run 

source venv/bin/activate

cd $TIMS_DIR/loaders/comp_loinc

# check the input files are there
if [[ ! -e merged_reasoned_loinc.owl ]] ; then
    wget https://github.com/loinc/comp-loinc/blob/main/data/output/merged_reasoned_loinc.owl?raw=true
    mv merged_reasoned_loinc.owl?raw=true merged_reasoned_loinc.owl
else
    echo "file found"
fi

# CONVERT to FHIR
echo "starting OAK"
python ontology-access-kit/src/oaklib/cli.py -i merged_reasoned_loinc.owl dump -o CodeSystem-CompLOINC.json -O fhirjson --include-all-predicates 2> oak.err > oak.log 
if [[ $? ]] ; then
    echo "OAK is done"
else
    echo "OAK seems to have had errors"
    exit 1
fi



