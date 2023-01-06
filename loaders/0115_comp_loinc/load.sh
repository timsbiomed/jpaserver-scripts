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



f=CodeSystem-CompLOINC.json

echo "DIR:$DIR f:$f"

if [ -f "${DIR}/loading.txt" ] || [ -f "${DIR}/loaded.txt" ]; then
	echo Skipping: "$FILE"
	exit 0
fi

if curl -v -X PUT --header "Content-Type: application/fhir+json" \
	--header "Prefer: return=OperationOutcome" \
	--output "$DIR/${f}.response.txt" \
	-T "$DIR/$f" \
	"${HAPI_R4}/CodeSystem/rxnormjoe" > "$DIR/${f}.loading.txt" 2>&1; then
	
	mv "$DIR/${f}.loading.txt" "$DIR/${f}.loaded.txt"
else
    echo "load had issues"
fi


