#!/usr/bin/env bash
# gets the CLI and the hapi server


cd $TIMS_DIR/hapi



# DOWNLOAD the static content from TimsUI, put in $TIMS_DIR/static-files
if [[ ! -f TimsUI.tar ]] ; then
    wget -q https://github.com/HOT-Ecosystem/TimsUI/releases/download/v1.0/TimsUI.tar 2> /dev/null
    mkdir $TIMS_DIR/static-files
    cd $TIMS_DIR/static-files
    tar xvf  $TIMS_DIR/hapi/TimsUI.tar
    cd $TIMS_DIR/hapi
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
if [[ ! -f $TIMS_DIR/hapi/ROOT.war ]] ;then 

     # lucene doesn't appear to work with 6.0. The application.yaml needs a different line, and that didn't make it happy either.
     #wget -q https://github.com/HOT-Ecosystem/hapi-fhir-jpaserver-starter/releases/download/v6.0.1/ROOT.war 2> /dev/null
     wget -q https://github.com/HOT-Ecosystem/hapi-fhir-jpaserver-starter/releases/download/v5.7.x/ROOT.war 2> /dev/null

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
#if [[ ! -f $TIMS_DIR/hapi/application.yaml ]] ;then 
#    ln -s  application_phenotype_pg.yaml application.yaml
#fi
# Edit application.yaml to point to $TIMS_DIR/static-files, and copy at the same time
cd $TIMS_DIR
cat $TIMS_DIR/hapi/application_pg.yaml | sed  "s|XXstatic-filesXX|$TIMS_DIR/static-files/|g" >> $TIMS_DIR/hapi/application.yaml

cd $TIMS_DIR/hapi

# DOWNLOAD fhir-owl 
if [[ !  -d $TIMS_DIR/lib ]] ; then
    mkdir $TIMS_DIR/lib 
fi

if [[ !  -f $TIMS_DIR/lib/fhir-owl-1.1.0.jar ]] ; then
    wget https://github.com/HOT-Ecosystem/fhir-owl/releases/download/Oct_24_2022/fhir-owl-1.1.0.jar
    ls fhir-owl-1.1.0.jar
    mv fhir-owl-1.1.0.jar $TIMS_DIR/lib
fi



