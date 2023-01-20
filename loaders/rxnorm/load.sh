#!/usr/bin/env bash
#
# load.sh for RxNORM CSV

set -euo pipefail

cd $TIMS_DIR/loaders/rxnorm

FILE="codesystem.zip"

FILE_SIZE=`ls -l $FILE | awk '{print $5}'`
echo "FILE SIZE $FILE_SIZE FILE $FILE"
ls $FILE
if (( $FILE_SIZE < 10000 )) ; then
    echo "input file is suspiciously small. try git lfs install, the git lfs pull SnomedCT_USEditionRF2_PRODUCTION_20210901T120000Z.zip"
    echo "(I'm thinking it's just a reference file and git-lfs needs to be installed and run to pull the real file down.)"
fi

"${TIMS_DIR}/hapi/hapi-fhir-cli" upload-terminology \
  -d "$FILE" \
  -v r4 \
  -t "${HAPI_R4}" \
  -u "http://purl.bioontology.org/ontology/RXNORM" > "$FILE.log" 2>&1

if [[ $? ]]; then	
    echo "ERROR, rxnorm load of $f  had issues"
fi


