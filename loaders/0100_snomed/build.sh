#!/usr/bin/env bash

$FILE="SnomedCT_USEditionRF2_PRODUCTION_20210901T120000Z.zip"
if [[ ! -e $FILE] ; then
    echo "ERROR no file. SNOMED download TBD, need to deal with logins."
    exit 1;
fi
