#!/usr/bin/env bash
# gets a v6 HAPI jpaserver-starter


cd $TIMS_DIR/hapi


# DOWNLOAD hapi-fhir-jpaserver-starter
if [[ ! -f ROOT_6.0.1.war ]] ;then 

    # rm previouis ROOT.war in case it's a 5.x one.. wget will not download over it, but create ROOT.war.1
    rm ROOT.war

     # lucene doesn't appear to work with 6.0. The application.yaml needs a different line, and that didn't make it happy either.
     wget -q https://github.com/HOT-Ecosystem/hapi-fhir-jpaserver-starter/releases/download/v6.0.1/ROOT.war 2> /dev/null
     mv ROOT.war ROOT_6.0.1.war

     set +e
     set +o pipefail
       jar tvf ROOT_6.0.1.war | grep tomcat
       if (( $? )) ; then
          echo "ERROR: This isn't a properly build ROOT.war. It's missing tomcat."
          echo "It should be built with spring-boot:repackage -Pboot. Don't take my word for it, read the README in hapi-fhir-jpaserver-starter"
          echo "** removing bogus ROOT.war **"
          rm ROOT_6.0.1.war
          exit 1
       else 
          echo "INFO: WAR looks good. I saw tomcat stuff in there."
       fi
     set -e
     set -o pipefail
else
    echo "INFO: hapi-fhir-jpaserver-starter ROOT.war seems to be already installed."
fi





