#!/usr/bin/env bash
# removes things installed by install.sh. It cleans the install, not clean and install.


# See http://stackoverflow.com/questions/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done

# This is the bin directory. 
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"


cd $DIR/../hapi



# CLI
rm -rf hapi-fhir-cli
rm hapi-fhir-cli.jar
rm hapi-fhir-cli.cmd
rm hapi-fhir-6.1.3-cli.zip


# SERVER:  hapi-fhir-jpaserver-starter
rm ROOT.war


# DOWNLOAD fhir-owl 
rm fhir-owl-1.1.0.jar
rm $DIR/../lib/fhir-owl-1.1.0.jar



