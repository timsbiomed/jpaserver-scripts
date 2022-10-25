#!/usr/bin/env bash

# dowload ICD
FILE="icd10cm_tabular_2022.xml" 
if [[ ! -f $FILE ]] ; then
    echo "ERROR, no file. ICD download TBD, need to deal with logins."
    exit 1;
fi
