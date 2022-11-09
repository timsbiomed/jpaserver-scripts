#!/usr/bin/env bash
# gets the CLI and the hapi server


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



# DOWNLOAD CLI
FILE=hapi-fhir-cli
if [[ ! -f $FILE ]] ;then
    wget -q https://github.com/hapifhir/hapi-fhir/releases/download/v6.1.3/hapi-fhir-6.1.3-cli.zip  2> /dev/null
    unzip hapi-fhir-6.1.3-cli.zip
    rm hapi/hapi-fhir-6.1.3-cli.zip
else
    echo "INFO: hapi-fhir cli seems to be already installed."
fi



# DOWNLOAD hapi-fhir-jpaserver-starter
if [[ ! -f $DIR/../hapi/ROOT.war ]] ;then 
     wget -q https://github.com/HOT-Ecosystem/hapi-fhir-jpaserver-starter/releases/download/Nov-09-2022/ROOT.war 2> /dev/null
     set +e
     set +o pipefail
       jar tvf ROOT.war | grep tomcat
       if (( $? )) ; then
          echo "ERROR: This isn't a properly build ROOT.war. It's missing tomcat."
          echo "It should be built with spring-boot:repackage -Pboot. Don't take my word for it, read the README in hapi-fhir-jpaserver-starter"
          echo "** removing bogus ROOT.war **"
          rm ROOT.war
          exit 1
       else 
          echo "INFO: WAR looks good. I saw tomcat stuff in there."
       fi
     set -e
     set -o pipefail
     mv ROOT.war $DIR/../hapi/
else
    echo "INFO: hapi-fhir-jpaserver-starter ROOT.war seems to be already installed."
fi
