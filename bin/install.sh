#!/usr/bin/env bash

# get the CLI

# See http://stackoverflow.com/questions/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd $DIR/../hapi

FILE=hapi-fhir-cli
if [[ ! -f $FILE ]] ;then
    wget https://github.com/hapifhir/hapi-fhir/releases/download/v6.1.3/hapi-fhir-6.1.3-cli.zip
    unzip hapi-fhir-6.1.3-cli.zip
    rm hapi/hapi-fhir-6.1.3-cli.zip
else
    echo "INFO: hapi-fhir cli seems to be already installed."
fi
