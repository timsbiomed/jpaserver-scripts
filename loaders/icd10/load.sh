#!/usr/bin/env bash
#
# load.sh for icd10
# looks for file in the ontology cache, named icd10cm_tabular_2022.xml  explicitly

set -uo pipefail

cd $TIMS_DIR/loaders/icd10

FILE="${TIMS_DIR}/../ontology_cache/icd10cm_tabular_2022.xml"
FILE_SIZE=`ls -l $FILE | awk '{print $5}'`
if (( $FILE_SIZE < 10000 )) ; then
    echo "input file is suspiciously small. try git lfs install, the git lfs pull icd10cm_tabular_2022.xml"
    echo "(I'm thinking it's just a reference file and git-lfs needs to be installed and run to pull the real file down.)"
    exit 1
else
    echo "found file"
fi

echo "uploading.."
"${TIMS_DIR}/hapi/hapi-fhir-cli" upload-terminology \
  -d "$FILE" \
  -v r4 \
  -t "${HAPI_R4}" \
  -u http://hl7.org/fhir/sid/icd-10-cm > "$FILE.log" 2>&1

if (( $? )); then	
    echo "ERROR icd10 load of $FILE  had issues, $?"
fi


