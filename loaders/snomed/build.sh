#!/usr/bin/env bash

cd $TIMS_DIR/loaders/snomed

FILE="SnomedCT_USEditionRF2_PRODUCTION_20210901T120000Z.zip"
if [[ ! -e $TIMS_DIR/ontology_cache/$FILE ]] ; then
    echo "ERROR no file in ontology_cache. $FILE"
    exit 1;
fi
