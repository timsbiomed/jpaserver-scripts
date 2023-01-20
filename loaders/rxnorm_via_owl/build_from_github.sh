#!/usr/bin/env bash
set -euo pipefail
source venv/bin/activate



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
if [[ !  -f "$DIR/${f}" ]] ; then
    wget https://github.com/HOT-Ecosystem/owl-on-fhir-content/raw/master/output/CodeSystem-RXNORM.json
else
    echo "RXNORM.json already downloaded."
fi




