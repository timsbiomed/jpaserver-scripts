#!/usr/bin/env bash
# dowload ICD
set -euo pipefail

cd $TIMS_DIR/loaders/icd10
FILE="icd10cm_tabular_2022.xml" 
if [[ ! -f $TIMS_DIR/../ontology_cache/$FILE ]] ; then
    echo "ERROR no file in ontology_cache. $FILE, $TIMS_DIR/ontology_cache/$FILE "
    exit 1;
fi
