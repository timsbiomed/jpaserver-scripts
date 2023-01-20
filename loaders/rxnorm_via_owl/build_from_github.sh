#!/usr/bin/env bash
set -euo pipefail
source venv/bin/activate



cd $TIMS_DIR/loaders/rxnorm_via_owl
f=CodeSystem-RXNORM.json

# check the input files are there
if [[ !  -f "${f}" ]] ; then
    wget https://github.com/HOT-Ecosystem/owl-on-fhir-content/raw/master/output/CodeSystem-RXNORM.json
else
    echo "CodeSystem-RXNORM.json already downloaded."
fi




