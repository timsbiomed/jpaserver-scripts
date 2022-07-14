#!/usr/bin/env bash
set -x
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

source "${DIR}/.env"
if [ -f "$DIR/.env-local" ]; then
	source "$DIR/.env-local"
fi

RESET=$(date +%Y_%m_%d_%H_%M_%S)_reset

echo Stopping systemd timsts.service ...
systemctl stop timsts.service

echo Moving db and index to $RESET ...
"${DIR}/setup-db.sh" move $RESET

echo Starting systemd timsts.service ...
systemctl start timsts.service

sleep 60

echo Loading content ...
"${DIR}/loaders.sh"


