#!/usr/bin/env bash
# dowload ICD

# See http://stackoverflow.com/questions/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd $DIR
FILE="icd10cm_tabular_2022.xml" 
if [[ ! -f ../../ontology_cache/$FILE ]] ; then
    echo "ERROR no file in ontology_cache. $FILE"
    exit 1;
fi
