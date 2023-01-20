#!/usr/bin/env bash
set -euo pipefail

# Super basic download and convert SO to FHIR CodeSystem for load,
# reads: so.owl
# writes: so_CodeSystem.json

cd $TIMS_DIR/loaders/so

# get  SO
if [[ !  -f so.owl ]] ; then
    echo "getting SO file"
    wget -q http://purl.obolibrary.org/obo/so.owl  
else
    echo "SO file found"
fi

java -jar $TIMS_DIR/lib/fhir-owl-1.1.0.jar \
    -i so.owl \
    -o so_CodeSystem.json \
    -id so \
    -name "SequenceOntology" \
    -mainNs http://purl.obolibrary.org/obo/SO_  \
    -status active \
    -codeReplace "_,:" \
    -s http://www.geneontology.org/formats/oboInOwl#hasExactSynonym \
  -t "Sequence Ontology" \
  -content complete \
  -descriptionProp http://purl.org/dc/elements/1.1/subject \
  -useFhirExtension \
  -dateRegex "(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})" 

