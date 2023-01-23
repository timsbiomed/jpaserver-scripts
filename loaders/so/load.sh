#!/usr/bin/env bash
#
# load.sh for Sequence Ontology CodeSystem, into server at $HAPI_R4
#   reads:  so_CodeSystem.json

set -uo pipefail
cd $TIMS_DIR/loaders/so
FILE="so_CodeSystem.json"
	
echo loading: $FILE
	
curl -v -X PUT --header "Content-Type: application/fhir+json" \
	--header "Prefer: return=OperationOutcome" \
	--output "$FILE.response.txt" \
	-T "$FILE" \
	"${HAPI_R4}/CodeSystem/so" > "${FILE}.log" 2>&1

if (( $? )); then	
    echo "ERROR, SO load of $FILE  had issues"
fi
	

