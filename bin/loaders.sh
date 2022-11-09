#!/usr/bin/env bash
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

source "${DIR}/env.sh"
if [ -f "$DIR/.env-local" ]; then
	source "$DIR/.env-local"
fi

#for d in $(find "$(cd ${DIR}/../loaders; pwd)" -mindepth 1 -maxdepth 1 -type d | sort); do
# is order really important?

for d in $DIR/../loaders/* ; do
  if [[ -d $d ]] ; then		
	if [[  $d == *.off ]]; then
		echo skipping loader: $d
		continue
	fi
	
	if [ -f "${d}/build.sh" ]; then
	    echo building: $d
		"${d}/build.sh"
	fi
	
	if [ -f "${d}/load.sh" ]; then
	    echo loading: $d
		"${d}/load.sh"
	fi
  fi
done

