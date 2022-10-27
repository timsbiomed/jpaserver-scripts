#!/usr/bin/env bash

# This script just passes args to the HAPI CLI. The idea is that users don't need to figure
# out where the cli is under this setup, which version is being used, etc.
# the "${DIR}/../hapi/hapi-fhir-cli" is probably symlinked to a version specific file.


#set -x
set -e
set -u
set -o pipefail
set -o noclobber
#set -f # no globbing
#shopt -s failglob # fail if glob doesn't expand

# Setting DIR to directory of this script file.
# See http://stackoverflow.com/questions/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source "${DIR}/env.sh"
if [ -f "$DIR/.env-local" ]; then
	source "$DIR/.env-local"
fi

"${DIR}/../hapi/hapi-fhir-cli" "$@"


