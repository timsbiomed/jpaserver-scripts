#export HAPI_R4="http://localhost:8080/fhir"
#export HAPI_R4="http://localhost:8088/fhir"

export HAPI_R4="http://localhost:8001/fhir"
    # trying not to interfere with "tester" paragraph in application.yaml set to 8000


# mac
TIMSTS_DIR=/Users/roederc/work/git_tims/jpaserver-scripts

# postgresapp on my mac
export PGHOST=localhost
export PGPORT=5432
export PGDATABASE=hapifhir
export PGUSER=postgres
export PGPASSWORD=it_matters_not

# these variables are used by some of the application.yaml files
export PG_HOST=$PGHOST
export PG_PORT=$PGPORT
export PG_DATABASE=$PGDATABASE
export PG_DB=$PGDATABASE
export PG_USER=$PGUSER
export PG_PASSWORD=$PGPASSWORD
