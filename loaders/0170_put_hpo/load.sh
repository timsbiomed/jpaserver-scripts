#!/usr/bin/env bash
#
# load.sh for HPO
# looks for  files named <resource>_<ontology>.json in this directory

# Ex. CodeSystem-hpo.json
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

f=hp-CodeSystem.json
	
if [ -f "$DIR/${f}.loaded.txt" ] || [ -f "$DIR/${f}.loading.txt" ] ; then
	echo Already loaded/loading: $f
fi
	
echo loading: $f
	
if curl -v -X PUT --header "Content-Type: application/fhir+json" \
	--header "Prefer: return=OperationOutcome" \
	--output "$DIR/${f}.response.txt" \
	-T "$DIR/$f" \
	"${HAPI_R4}/CodeSystem/hpo" > "$DIR/${f}.loading.txt" 2>&1; then
	
	mv "$DIR/${f}.loading.txt" "$DIR/${f}.loaded.txt"
fi

