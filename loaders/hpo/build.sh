#!/usr/bin/env bash
set -euo pipefail

# Super basic download and convert HPO to FHIR for load
# Names the output file in accordance with want the load.sh
#  script expects.


cd $TIMS_DIR/hpo

# get hpo
if [[ !  -f hp.owl ]] ; then
    echo "getting HPO"
    wget -q https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/master/hp.owl 2> /dev/null
else
    echo "HPO file found"
fi

# includes bits of CHEBI etc, file is about 2x in size.
java -jar $TIMS_DIR/lib/fhir-owl-1.1.0.jar \
    -i hp.owl \
    -o $TIMS_DIR/loaders/hpo/hp-CodeSystem.json \
    -id hpo \
    -name "HumanPhenotypeOntology" \
    -mainNs http://purl.obolibrary.org/obo/HP_  \
    -status active \
    -codeReplace "_,:" \
    -s http://www.geneontology.org/formats/oboInOwl#hasExactSynonym \
  -t "Human Phenotype Ontology" \
  -content complete \
  -descriptionProp http://purl.org/dc/elements/1.1/subject \
  -useFhirExtension \
  -dateRegex "(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})" 

