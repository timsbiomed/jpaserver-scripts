#!/usr/bin/env bash
#
# load.sh for mondo
# looks for  files named <ontology>-<resource>.json, in this directory

# Ex. mondo-CodeSystem.json
set -uo pipefail

cd $TIMS_DIR/loaders/mondo
f=mondo-CodeSystem.json
	
	
curl -v -X PUT --header "Content-Type: application/fhir+json" \
	--header "Prefer: return=OperationOutcome" \
	--output "$f.response.txt" \
	-T "$f" \
	"${HAPI_R4}/CodeSystem/mondo" > "${f}.log" 2>&1

if (( $? )); then	
    echo "ERROR, mondo load of $f  had issues"
fi

