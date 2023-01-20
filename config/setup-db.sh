#!/usr/bin/env bash

# usage: setup-db.sh 
# usage: setup-db.sh  <move> <suffix>

# This script does any DB setup needed before starting HAPI. It basically
# calls create_datbase in the .env file that calls postgres to create the
# database timsts with a user of timsts.
# It can be called with $1 set to "move" to move the database and the index to start over.
# $2 would be the suffix name to move the database and index to.
# 
# functions used here are in .env
#
# REQUIRES environment variables:
#export PG_HOST=YYYYYY
#export PG_PORT=5432
#export PG_POSTGRES=XXXXXX
#
# Postgres wants these:
#export PGHOST=YYYYYY
#export PGPORT=5432
#export PGDBATABASE=timsts
#export PGUSER=XXXXXX
#export PGPASSWORD=XXXXXX
# https://www.postgresql.org/docs/current/libpq-envars.html

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

