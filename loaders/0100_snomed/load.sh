#!/usr/bin/env bash
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

source "${DIR}/../../bin/.env"
if [ -f "${DIR}/../../bin/.env-local" ]; then
	source "${DIR}/../../bin/.env-local"
fi


FILE="${DIR}/../../ontology_cache/SnomedCT_USEditionRF2_PRODUCTION_20210901T120000Z.zip"

if [ -f "${DIR}/loading.txt" ] || [ -f "${DIR}/loaded.txt" ]; then
	echo Skipping: "$FILE"
	exit 0
fi

if "${DIR}/../../bin/hapi-cli.sh" \
upload-terminology \
-d "$FILE" \
-v r4 \
-t "${HAPI_R4}" \
-u http://snomed.info/sct > "${DIR}/loading.txt" 2>&1; then
	mv "${DIR}/loading.txt"  "${DIR}/loaded.txt"
fi

