#!/usr/bin/env bash
set -euo pipefail
source venv/bin/activate


cd $TIMS_DIR/loaders/rxnorm_via_owl


# check the input files are there
# TODO, this isn't a canonical location
if [[ ! -e RXNORM.ttl ]] ; then
    wget https://media.githubusercontent.com/media/HOT-Ecosystem/owl-on-fhir-content/master/input/RXNORM.ttl
else
    echo "file found"
fi

# Convert RDF dialect
if [[ ! -e ncbo2owl.pl ]] ; then
    wget https://raw.githubusercontent.com/INCATools/semantic-sql/main/utils/ncbo2owl.pl
else
    echo "found ncbo2owl.pl"
fi
chmod 755 ncbo2owl.pl

cat RXNORM.ttl | ./ncbo2owl.pl > RXNORM_fixed.ttl
echo "done"
ls RXNORM_fixed.ttl

# CONVERT to FHIR
runoak -i RXNORM_fixed.ttl dump -o CodeSystem-RXNORM.json -O fhirjson --include-all-predicates

// PREPARE HAPI CLI ZIP
# https://smilecdr.com/docs/terminology/uploading.html
# https://www.nlm.nih.gov/research/umls/rxnorm/overview.html#:~:text=In%20addition%20to%20the%20fully,form%20%2F%20ingredient%20%2B%20dose%20form%20group



