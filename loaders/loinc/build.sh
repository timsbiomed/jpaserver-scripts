#!/usr/bin/env bash
set -euo pipefail

# dowload LOINC 2.72 (version is important, 2.73 breaks the HAPI LOINC loader as of 10/2022)


cd $TIMS_DIR/loaders/loinc
FILE="Loinc_2.72.zip"
if [[ ! -f $TIMS_DIR/../ontology_cache/$FILE ]] ; then
    echo "ERROR no file in ontology_cache. $FILE"
    exit 1;
else
    echo "found file $FILE "
fi
