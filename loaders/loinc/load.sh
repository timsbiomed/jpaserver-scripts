#!/usr/bin/env bash
#
# load.sh for loinc
# looks for file in the ontology cache, named Loinc_2.72.zip explicitly

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

FILE="${DIR}/../../../ontology_cache/Loinc_2.72.zip"
FILE_SIZE=`ls -l $FILE | awk '{print $5}'`
if (( $FILE_SIZE < 10000 )) ; then
    echo "input file is suspiciously small. try git lfs install, the git lfs pull Loinc_2.72.zip"
    echo "(I'm thinking it's just a reference file and git-lfs needs to be installed and run to pull the real file down.)"
fi

if [ -f "${DIR}/loading.txt" ] || [ -f "${DIR}/loaded.txt" ]; then
	echo Skipping: "$FILE"
	exit 0
fi

if "${DIR}/../../fhir/hapi-fhi-cli" \
upload-terminology \
  -d "$FILE" \
  -v r4 \
  -t "${HAPI_R4}" \
  -u http://loinc.org > "${DIR}/loading.txt" 2>&1; then
	mv "${DIR}/loading.txt"  "${DIR}/loaded.txt"
fi

