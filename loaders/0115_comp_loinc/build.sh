#!/usr/bin/env bash
set -euo pipefail
source venv/bin/activate


# This version downloads from HOT-Ecosystem/owl-on-fhir-content and doesn't run OAK locally

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
 
############################# fun starts here #####################



# check the input files are there
if [[ ! -e CodeSystem-CompLOINC.json ]] ; then
    wget https://github.com/HOT-Ecosystem/owl-on-fhir-content/blob/master/output/CodeSystem-CompLOINC.json?raw=true
    mv CodeSystem-CompLOINC.json?raw=true CodeSystem-CompLOINC.json
else
    echo "file found"
fi




