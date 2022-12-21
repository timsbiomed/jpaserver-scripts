#!/usr/bin/env bash
#
# load.sh for RxNORM CSV

set -euo pipefail

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



FILE="codesystem.zip"

if [ -f "${DIR}/loading.txt" ] || [ -f "${DIR}/loaded.txt" ]; then
	echo Skipping: "$FILE"
	exit 0
fi

FILE_SIZE=`ls -l $FILE | awk '{print $5}'`
echo "FILE SIZE $FILE_SIZE FILE $FILE"
ls $FILE
if (( $FILE_SIZE < 10000 )) ; then
    echo "input file is suspiciously small. try git lfs install, the git lfs pull SnomedCT_USEditionRF2_PRODUCTION_20210901T120000Z.zip"
    echo "(I'm thinking it's just a reference file and git-lfs needs to be installed and run to pull the real file down.)"
fi

if "${DIR}/../../bin/hapi-cli.sh" \
upload-terminology \
-d "$FILE" \
-v r4 \
-t "${HAPI_R4}" \
-u "http://purl.bioontology.org/ontology/RXNORMI" > "${DIR}/loading.txt" 2>&1; then
	mv "${DIR}/loading.txt"  "${DIR}/loaded.txt"
fi

