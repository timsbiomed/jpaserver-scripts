#!/usr/bin/env bash
#
# load.sh for RxNORM CSV

set -uo pipefail

cd $TIMS_DIR/loaders/comp_loinc
f=CodeSystem-CompLOINC.json


curl -v -X PUT --header "Content-Type: application/fhir+json" \
	--header "Prefer: return=OperationOutcome" \
	--output "$f.response.txt" \
	-T "$f" \
	"${HAPI_R4}/CodeSystem/comploinc" > "${f}.log" 2>&1

if (( $? )); then	
    echo "ERROR comp_loinc load of $f  had issues"
fi


