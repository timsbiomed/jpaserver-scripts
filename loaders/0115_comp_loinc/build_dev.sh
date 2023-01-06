#!/usr/bin/env bash
set -euo pipefail
source venv/bin/activate


# assumes install.sh has been run

# See http://stackoverflow.com/questions/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source "${DIR}/../../bin/env.sh"
if [ -f "${DIR}/../../bin/.env-local" ]; then
	source "${DIR}/../../bin/.env-local"
fi
cd $DIR
 
############################# fun starts here #####################

# check the input files are there
if [[ ! -e merged_reasoned_loinc.owl ]] ; then
    wget https://github.com/loinc/comp-loinc/blob/main/data/output/merged_reasoned_loinc.owl?raw=true
    mv merged_reasoned_loinc.owl?raw=true merged_reasoned_loinc.owl
else
    echo "file found"
fi

# CONVERT to FHIR
echo "starting OAK"
python ontology-access-kit/src/oaklib/cli.py -i merged_reasoned_loinc.owl dump -o codesystem.json -O fhirjson --include-all-predicates 2> oak.err > oak.log 
echo "OAK is done"



