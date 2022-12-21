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

set +e
  mkdir $DIR/../lib
set -e


cd $DIR/../hapi



# DOWNLOAD the static content from TimsUI, put in $DIR/static-files
if [[ ! -f TimsUI.tar ]] ; then
    wget -q https://github.com/HOT-Ecosystem/TimsUI/releases/download/v1.0/TimsUI.tar 2> /dev/null
    mkdir static-files
    cd static-files
    tar xvz  ../TimsUI.tar
fi



# DOWNLOAD CLI
FILE=hapi-fhir-cli
if [[ ! -f $FILE ]] ;then
    wget -q https://github.com/hapifhir/hapi-fhir/releases/download/v6.1.3/hapi-fhir-6.1.3-cli.zip  2> /dev/null
    unzip hapi-fhir-6.1.3-cli.zip
    rm hapi-fhir-6.1.3-cli.zip
else
    echo "INFO: hapi-fhir cli seems to be already installed."
fi



# DOWNLOAD hapi-fhir-jpaserver-starter
if [[ ! -f $DIR/../hapi/ROOT.war ]] ;then 

     # lucene doesn't appear to work with 6.0. The application.yaml needs a different line, and that didn't make it happy either.
     #wget -q https://github.com/HOT-Ecosystem/hapi-fhir-jpaserver-starter/releases/download/v6.0.1/ROOT.war 2> /dev/null
     wget -q https://github.com/HOT-Ecosystem/hapi-fhir-jpaserver-starter/releases/download/v5.7.0/ROOT.war 2> /dev/null

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
else
    echo "INFO: hapi-fhir-jpaserver-starter ROOT.war seems to be already installed."
fi


# copy to  application.yaml
#if [[ ! -f $DIR/../hapi/application.yaml ]] ;then 
#    ln -s  application_phenotype_pg.yaml application.yaml
#fi
# Edit application.yaml to point to $DIR/static-files, and copy at the same time
rm application.yaml
cat ../hapi/application_pg.yaml | sed -e "s/XXstatic-filesXX/$DIR\/static-files/" >> ../hapi/application.yaml


# DOWNLOAD fhir-owl 
if [[ !  -f $DIR/../lib/fhir-owl-1.1.0.jar ]] ; then
    wget https://github.com/HOT-Ecosystem/fhir-owl/releases/download/Oct_24_2022/fhir-owl-1.1.0.jar
    ls fhir-owl-1.1.0.jar
    mv fhir-owl-1.1.0.jar $DIR/../lib
fi



