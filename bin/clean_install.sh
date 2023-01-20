#!/usr/bin/env bash
# removes things installed by install.sh. It cleans the install, not clean and install.


cd $TIMS_DIR/../hapi


# CLI
rm -rf hapi-fhir-cli
rm hapi-fhir-cli.jar
rm hapi-fhir-cli.cmd
rm hapi-fhir-6.1.3-cli.zip


# SERVER:  hapi-fhir-jpaserver-starter
rm ROOT.war


# DOWNLOAD fhir-owl 
rm fhir-owl-1.1.0.jar
rm $TIMS_DIR/lib/fhir-owl-1.1.0.jar



