#!/usr/bin/env bash

# This script does any DB setup needed before starting HAPI
# It can be called with $1 set to "move" to move the database and the index to start over.
# $2 would be the suffix name to move the database and index to.
# 

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

if [ -f "$DIR/.env-local" ]; then
	source "$DIR/.env-local"
fi
source "${DIR}/.env"


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

