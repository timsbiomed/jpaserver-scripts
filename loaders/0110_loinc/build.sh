#!/usr/bin/env bash

# dowload LOINC 2.72 (version is important, 2.73 breaks the HAPI LOINC loader as of 10/2022)

FILE="Loinc_2.72.zip"
if [[ ! -f $FILE ]] ; then
    echo "ERROR no file. LOINC download TBD, need to deal with logins."
    exit 1;
fi
