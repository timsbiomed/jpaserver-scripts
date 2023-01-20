#!/usr/bin/env bash
#set -x
set -e
set -u
set -o pipefail

# See http://stackoverflow.com/questions/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source "${DIR}/../bin/env.sh"
if [ -f "$DIR/../bin/.env-local" ]; then
	source "$DIR/../bin/.env-local"
fi

. $DIR/../bin/profile.sh # for PG vars
env | grep PG_ 
if (( $? )) ; then
    echo "ERROR:missing PG_* environment variables used in the applicaiton.yaml"
    echo "These are distinct from the PG variables postgres uses that do not have underscores."
    exit 1
fi

# RUN
exec java -Xmx10G -jar "${DIR}/../hapi/ROOT_6.0.1.war" --spring.config.location="${DIR}/../hapi/" >> ${DIR}/../hapi.log &

