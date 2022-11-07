#!/usr/bin/env bash
set -euo pipefail

# Super basic download and convert HPO to FHIR for load
# Names the output file in accordance with want the load.sh
#  script expects.

# See http://stackoverflow.com/questions/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source "${DIR}/../../bin/env.sh"
if [ -f "${DIR}/../../bin/.env-local" ]; then
	source "${DIR}/../../bin/.env-local"
fi

# get fhir-owl to convert
if [[ !  -f $DIR/../../lib/fhir-owl-1.1.0.jar ]] ; then
    wget https://github.com/HOT-Ecosystem/fhir-owl/releases/download/Oct_24_2022/fhir-owl-1.1.0.jar
    mv fhir-owl-1.1.0.jar $DIR/../../lib
fi


# get hpo
if [[ !  -f hp.owl ]] ; then
    wget https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/master/hp.owl
    #wget https://github.com/obophenotype/human-phenotype-ontology/archive/refs/tags/v2022-06-11.tar.gz
fi

# includes bits of CHEBI etc, file is about 2x in size.
java -jar $DIR/../../lib/fhir-owl-1.1.0.jar \
    -i hp.owl \
    -o $DIR/CodeSystem-hpo.json \
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

