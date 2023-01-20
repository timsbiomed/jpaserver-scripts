#!/usr/bin/env bash

# See http://stackoverflow.com/questions/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd $DIR
FILE="SnomedCT_USEditionRF2_PRODUCTION_20210901T120000Z.zip"
if [[ ! -e ../../../ontology_cache/$FILE ]] ; then
    echo "ERROR no file in ontology_cache. $FILE"
    exit 1;
fi
