#!/usr/bin/env bash
set -euo pipefail

# Super basic download and convert SO to FHIR CodeSystem for load,
# reads: so.owl
# writes: so_CodeSystem.json

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



# get  SO
if [[ !  -f so.owl ]] ; then
    echo "getting SO file"
    wget -q http://purl.obolibrary.org/obo/so.owl  
else
    echo "SO file found"
fi

#java -jar $DIR/../../lib/fhir-owl-1.1.0.jar \
java -jar /Users/roederc/work/deploy/jpaserver-scripts/lib/fhir-owl-1.1.0.jar \
    -i so.owl \
    -o $DIR/so_CodeSystem.json \
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

