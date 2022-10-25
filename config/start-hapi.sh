#i!/usr/bin/env bash
#set -x
set -e
set -u
set -o pipefail
set -o noclobber
#set -f # no globbing
#shopt -s failglob # fail if glob doesn't expand

# See http://stackoverflow.com/questions/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source "${DIR}/../bin/.env"
if [ -f "$DIR/../bin/.env-local" ]; then
	source "$DIR/../bin/.env-local"
fi

#wget https://github.com/HOT-Ecosystem/hapi-fhir-jpaserver-starter/releases/download/Oct_24_2022/ROOT.war

exec java -Xmx10G -jar "${DIR}/../hapi/hapi.jar" --spring.config.location="${DIR}/../hapi/"
