#!/usr/bin/env bash
set -euo pipefail
# Super basic conversion of RxNorm "pills only", names and IDs, that's all for now.
# assumes files are available in ontology_cache

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

cd $DIR




# check the input files are there
if [[ ! -e ../../../ontology_cache/rxnorm ]] ; then
    echo "error, no rxnorm in ontology_chache."
    exit 1;
else
    echo "file found"
fi

# https://smilecdr.com/docs/terminology/uploading.html
# https://www.nlm.nih.gov/research/umls/rxnorm/overview.html#:~:text=In%20addition%20to%20the%20fully,form%20%2F%20ingredient%20%2B%20dose%20form%20group

echo "CODE,DISPLAY" > concepts.csv
cat ../../../ontology_cache/rxnorm/rrf/RXNCONSO.RRF | awk -F\| ' $12=="RXNORM" &&  $13=="IN" {print $14","$15 }' >> concepts.csv


cat > codesystem.json <<HERE_DOC
{
	"resourceType": "CodeSystem",
	"url": "http://purl.bioontology.org/ontology/RXNORMI",
	"name": "RxNormI",
	"description": "A very simple version of RxNorm concepts for ingredients",
	"status": "active",
	"publisher": "HOT-ecosystem / TIMS",
	"date": "2022-12-20",
	"content": "not-present"
}
HERE_DOC

rm -f codesystem.zip
zip codesystem concepts.csv codesystem.json

