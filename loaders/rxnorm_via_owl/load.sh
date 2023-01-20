#!/usr/bin/env bash
#
# load.sh for RxNorm processed throug OAK to JSON
# looks for  files named <ontology>-<resource>.json, in this directory

# Ex. mondo-CodeSystem.json
set -uo pipefail

cd $TIMS_DIR/loaders/rxnorm_via_owl
f=CodeSystem-RXNORM.json

curl -v -X PUT --header "Content-Type: application/fhir+json" \
	--header "Prefer: return=OperationOutcome" \
	--output "${f}.response.txt" \
	-T "$f" \
	"${HAPI_R4}/CodeSystem/core" > "${f}.log" 2>&1

if (( $? )); then
    echo "ERROR, rxnorm_via_owl load had issues with $f"
fi

