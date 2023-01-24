#!/usr/bin/env bash
set -uo pipefail

env | grep PG 
if (( $? )) ; then
    echo "ERROR:missing PG* environment variables used in the application.yaml"
    exit 1
fi

psql -lqt | awk '{ print $1 }' | grep  $PGDATABASE
if (( $? )) ; then
    echo "INFO: databse \"$PGDATABASE\" does not exist, creating."
    createdb $PGDATABASE
else
    echo "INFO: found databse \"$PGDATABASE\"."
fi

# RUN
exec java -Xmx10G -jar "${TIMS_DIR}/hapi/ROOT.war" --spring.config.location="${TIMS_DIR}/hapi/" >> ${TIMS_DIR}/hapi.log &

