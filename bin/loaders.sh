#!/usr/bin/env bash
set -euo pipefail

LOADER_DIRS=(comp_loinc hpo icd10 loinc mondo rxnorm rxnorm_via_owl snomed so)

cd $TIMS_DIR/loaders
for DIR in ${LOADER_DIRS[@]} ; do
  echo $DIR
  if [[ -d $TIMS_DIR/loaders/$DIR ]] ; then		

	if [ -f "$TIMS_DIR/loaders/${DIR}/build.sh" ]; then
	    echo "building: $DIR"
		"$TIMS_DIR/loaders/${DIR}/build.sh"
        if (( $? )) ; then
            echo "ERROR building $DIR"
        fi
    else 
        echo "ERROR, no build script for $DIR"
        exit 1
	fi
	
	if [ -f "$TIMS_DIR/loaders/${DIR}/load.sh" ]; then
	    echo "loading: $DIR"
		"$TIMS_DIR/loaders/${DIR}/load.sh"
        if (( $? )) ; then
            echo "ERROR loading $DIR"
        fi
    else 
        echo "ERROR, no load script for $DIR"
        exit 1
	fi
  fi
done

