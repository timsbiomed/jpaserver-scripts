#!/usr/bin/env bash
set -euo pipefail


cd $TIMS_DIR

env | grep PG_ 
if (( $? )) ; then
    echo "ERROR:missing PG_* environment variables used in the applicaiton.yaml"
    echo "These are distinct from the PG variables postgres uses that do not have underscores."
    exit 1
fi

# RUN
exec java -Xmx10G -jar "${TIMS_DIR}/hapi/ROOT_6.0.1.war" --spring.config.location="${TIMS_DIR}/hapi/" >> ${TIMS_DIR}/hapi.log &

