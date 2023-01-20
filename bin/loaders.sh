#!/usr/bin/env bash
set -euo pipefail

LOADER_DIRS=(comp_loinc hpo icd10 loinc mondo rxnorm rxnorm_via_owl snomed so)

for DIR in $LOADER_DIRS ; do
  if [[ -d $DIR ]] ; then		
	
	if [ -f "${DIR}/build.sh" ]; then
	    echo "building: $DIR"
		"${DIR}/build.sh"
        if (( $? )) ; then
            echo "ERROR building $DIR"
        fi
    else 
        echo "ERROR, no build script for $DIR"
        exit 1
	fi
	
	if [ -f "${DIR}/load.sh" ]; then
	    echo "loading: $d"
		"${DIR}/load.sh"
        if (( $? )) ; then
            echo "ERROR loading $DIR"
        fi
    else 
        echo "ERROR, no load script for $DIR"
        exit 1
	fi
  fi
done

