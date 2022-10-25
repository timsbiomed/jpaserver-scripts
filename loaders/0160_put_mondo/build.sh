#!/usr/bin/env bash
set -euo pipefail

# super basic download and convert MONDO to FHIR for load

# get fhir-owl to convert
if [[ !  -f ../../lib/fhir-owl-1.1.0.jar ]] ; then
    wget https://github.com/HOT-Ecosystem/fhir-owl/releases/download/Oct_24_2022/fhir-owl-1.1.0.jar
    mv fhir-owl-1.1.0.jar ../../lib
fi


# get mondo
if [[ !  -f mondo.owl ]] ; then
    wget http://purl.obolibrary.org/obo/mondo.owl
fi

#FHIR_OWL_HOME=/Users/chris3/work/git_tims/fhir-owl/
#export CLASSPATH="$CLASSPATH:$FHIR_OWL_HOME"
#echo "Classpath is: $CLASSPATH"
#    -cp $CLASSPATH \

# includes bits of CHEBI etc, file is about 2x in size.
java -jar ../../lib/fhir-owl-1.1.0.jar \
    -i mondo.owl \
    -o mondo.json \
    -id mondo \
    -name "MondoDiseaseOntology" \
    -mainNs http://purl.obolibrary.org/obo/MD_  \
    -status active \
    -codeReplace "_,:" \
    -s http://www.geneontology.org/formats/oboInOwl#hasExactSynonym \
  -t "Mondo Disease Ontology" \
  -content complete \
  -descriptionProp http://purl.org/dc/elements/1.1/subject \
  -useFhirExtension \
  -dateRegex "(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})" 

