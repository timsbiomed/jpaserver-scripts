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


# There are lots of options for what kinds of terms to load from RxNorm, filter on column 13, TTY.
# using PSN today, though it has uniqueness issues. See below.
# BD - ?
# BN - Brand Name ex. Entresto
# PSN - Prescribable Name
# SBD  - Semantic Branded Drug 
# SBDG - Semantic Branded Dose Form Group
# SBDF - Semantic Branded Drug Form
# SBDC - Semantic Branded Drug Component
# IN - Ingredient
# PIN - Precise Ingredient
# SY - Synonym

# with PSN type, the same string may have more than 1 ID
if (( 0 )) ; then
    echo "CODE,AUI,SAB,DISPLAY,SAUI,SCUI,SDUI,CUI" > test.csv
    cat ../../../ontology_cache/rxnorm/rrf/RXNCONSO.RRF | awk -F\| ' $13=="PSN" {print $14","$8","$12","$15","$9","$10","$11","$1 }' >> test.csv

    # 34779 individual CODES 
    cat test.csv | awk -F, '{print $1}' | sort -u | wc -l
    # but 34297 unique strings, MEANING some strings have > 1 ID!!!
    cat test.csv | awk -F, '{print $4}' | sort -u | wc -l
    # ...and the other fields don't help
fi 


echo "CODE,DISPLAY" > concepts.csv
cat ../../../ontology_cache/rxnorm/rrf/RXNCONSO.RRF | awk -F\| ' $13=="PSN" {print $14","$15 }' >> concepts.csv
cat ../../../ontology_cache/rxnorm/rrf/RXNCONSO.RRF | awk -F\| ' $12=="RXNORM" &&  $13=="IN" {print $14","$15 }' >> concepts.csv


cat > codesystem.json <<HERE_DOC
{
	"resourceType": "CodeSystem",
	"url": "http://purl.bioontology.org/ontology/RXNORM",
	"name": "RxNorm",
	"description": "A very simple version of RxNorm concepts",
	"status": "active",
	"publisher": "HOT-ecosystem / TIMS",
	"date": "2022-12-20",
	"content": "not-present"
}
HERE_DOC

rm -f codesystem.zip
zip codesystem concepts.csv codesystem.json

