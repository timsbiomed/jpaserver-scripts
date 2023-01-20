#!/usr/bin/env bash
set -euo pipefail

# Super basic download and convert MONDO to FHIR for load
# Names the output file in accordance with want the load.sh
#  script expects.


cd $TIMS_DIR/loaders/mondo

# get mondo
if [[ !  -f mondo.owl ]] ; then
    echo "getting MONDO file"
    wget -q http://purl.obolibrary.org/obo/mondo.owl  2> /dev/null
else
    echo "MONDO file found"
fi

# includes bits of CHEBI etc, file is about 2x in size.
java -jar $TIMS_DIR/lib/fhir-owl-1.1.0.jar \
    -i mondo.owl \
    -o mondo-CodeSystem.json \
    -id mondo \
    -name "MondoDiseaseOntology" \
    -mainNs http://purl.obolibrary.org/obo/MONDO_  \
    -status active \
    -codeReplace "_,:" \
    -s http://www.geneontology.org/formats/oboInOwl#hasExactSynonym \
  -t "Mondo Disease Ontology" \
  -content complete \
  -descriptionProp http://purl.org/dc/elements/1.1/subject \
  -useFhirExtension \
  -dateRegex "(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})" 

