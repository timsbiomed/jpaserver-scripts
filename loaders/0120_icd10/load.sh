#!/usr/bin/env bash
#
# load.sh for icd10
# looks for file in the ontology cache, named icd10cm_tabular_2022.xml  explicitly

#set -x
set -e
set -u
set -o pipefail
set -o noclobber
#set -f # no globbing
#shopt -s failglob # fail if glob doesn't expand

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

FILE="${DIR}/../../../ontology_cache/icd10cm_tabular_2022.xml"
FILE_SIZE=`ls -l $FILE | awk '{print $5}'`
if (( $FILE_SIZE < 10000 )) ; then
    echo "input file is suspiciously small. try git lfs install, the git lfs pull icd10cm_tabular_2022.xml"
    echo "(I'm thinking it's just a reference file and git-lfs needs to be installed and run to pull the real file down.)"
fi


if [ -f "${DIR}/loading.txt" ] || [ -f "${DIR}/loaded.txt" ]; then
	echo Skipping: "$FILE"
	exit 0
fi

if "${DIR}/../../bin/hapi-cli.sh" \
upload-terminology \
-d "$FILE" \
-v r4 \
-t "${HAPI_R4}" \
-u http://hl7.org/fhir/sid/icd-10-cm > "${DIR}/loading.txt" 2>&1; then
	mv "${DIR}/loading.txt"  "${DIR}/loaded.txt"
fi


