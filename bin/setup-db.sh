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

source "${DIR}/source.sh"

if is_database timsts; then
	echo timsts db already exists
	
	if [ ${1-NONE} == "move" ]; then
		echo moving timsts db to timsts_$2
		disconnect_clients
		move_database $2
		
		if [ -d "${DIR}/../lucene-index" ]; then
			mv -f "${DIR}/../lucene-index" "${DIR}/../lucene-index_${2}"
		fi
	fi
else
	echo timsts NOT exists, creating it
	
	if [ ${1-NONE} == "move" ]; then
		echo timsts does not exist but asked to move
		exit 1
	fi
	create_database
fi

