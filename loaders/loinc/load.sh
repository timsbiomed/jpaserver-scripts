#!/usr/bin/env bash
#
# load.sh for loinc
# looks for file in the ontology cache, named Loinc_2.72.zip explicitly

set -euo pipefail

cd $TIMS_DIR/loaders/loinc

FILE="${TIMS_DIR}/ontology_cache/Loinc_2.72.zip"
FILE_SIZE=`ls -l $FILE | awk '{print $5}'`
if (( $FILE_SIZE < 10000 )) ; then
    echo "input file is suspiciously small. try git lfs install, the git lfs pull Loinc_2.72.zip"
    echo "(I'm thinking it's just a reference file and git-lfs needs to be installed and run to pull the real file down.)"
fi

"${TIMS_DIR}/hapi/hapi-fhi-cli"  upload-terminology \
  -d "$FILE" \
  -v r4 \
  -t "${HAPI_R4}" \
  -u http://loinc.org > "$FILE.log" 2>&1

if [[ $? ]]; then	
    echo "ERROR loinc load of $FILE  had issues"
fi
