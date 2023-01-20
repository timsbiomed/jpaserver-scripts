#!/usr/bin/env bash
#
# load.sh for HPO
# looks for  files named <resource>_<ontology>.json in this directory

# Ex. CodeSystem-hpo.json
set -uo pipefail

cd $TIMS_DIR/loaders/hpo
f=hp-CodeSystem.json
	
curl -v -X PUT --header "Content-Type: application/fhir+json" \
	--header "Prefer: return=OperationOutcome" \
	--output "$f.response.txt" \
	-T "${f}" \
	"${HAPI_R4}/CodeSystem/hpo" > "${f}.log" 2>&1

if (( $? )); then	
    echo "ERROR hpo load of $f  had issues"
fi
