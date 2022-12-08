#!/usr/bin/env bash

# dowload LOINC 2.72 (version is important, 2.73 breaks the HAPI LOINC loader as of 10/2022)

# See http://stackoverflow.com/questions/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd $DIR
FILE="Loinc_2.72.zip"
if [[ ! -f ../../../ontology_cache/$FILE ]] ; then
    echo "ERROR no file in ontology_cache. $FILE"
    exit 1;
fi
