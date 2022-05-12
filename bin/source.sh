
export PG_HOST=20.119.216.32
export PG_PORT=5432
export PG_POSTGRES=eb*rtkzM7jmR@G
export PG_DB=timsts
export PG_USER=timsts
export PG_PASSWORD=timsts

export HAPI_R4=http://localhost:8000/r4


# https://askubuntu.com/questions/1074871/bash-script-that-check-if-a-database-exist
function is_database() {
  PGPASSWORD="${PG_POSTGRES}" psql -U postgres -h "${PG_HOST}" -p "${PG_PORT}" -lqt | cut -d \| -f 1 | grep -wq $1
}

function create_database() {
  PGPASSWORD="${PG_POSTGRES}" psql -U postgres -h "${PG_HOST}" -p "${PG_PORT}" -c "CREATE DATABASE timsts OWNER timsts;"
}


function move_database() {
  PGPASSWORD="${PG_POSTGRES}" psql -U postgres -h "${PG_HOST}" -p "${PG_PORT}" -c "ALTER DATABASE timsts RENAME TO timsts_${1};"
}

function disconnect_clients(){
	GPASSWORD="${PG_POSTGRES}" psql -U postgres -h "${PG_HOST}" -p "${PG_PORT}" -c "SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'timsts'
  AND pid <> pg_backend_pid();"
}


