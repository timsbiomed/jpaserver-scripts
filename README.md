# jpaserver-scripts (private)
scripts to start and config the hapi-fhir-jpaserver-starter

This is a **private** repo so we don't have to sweat leaving passwords or data in here.

The reason for putting into git is so we can easily adapt this to laptop use.
I'm on macos, which doesn't have systemd. No attempt to address Windows here yet.
On mac, the plan is to use Docker on a -Pboot build ROOT.war. On mac, I tried to run the war
directly, with either jetty or tomcat as servlet containers to no avail. 

## TL;DR
- First off, install postgres if you want to use it. There's a step below where we have to decide between H2 and an install of postgres.
  - https://postgresapp.com/
  - I haven't written instructions for any configuration you have to do after installing it. It might be set up pretty well and the application.yaml ile here defaults to what I have for my postgresapp on my mac. Create the database called hapifhir.
- In a terminal window with a bash or z-shell, from the top-level directory of the git repo where you found this file:
  - git export <branch> > jpaserver-scripts.tar
  - copy that file to the machine or place you want to deploy on
  - make a directory for its contents: mkdir jpaserver-scripts; cd jpaserver-scripts
  - expand it: tar xvf ../jpaserver-scripts.tar
  - edit bin/profile.sh to have connection info to your postgres instance if you're doing that
  - edit hapi/application.yaml to set some things
    - the port you want to run on. Look for "server: port:"
    - connection info to your postgres instance if that's what you're using, or that you want H2
      - there are two paragraphs under "datasource", one for H2, and one for postgres.
      - If postgres, you'll use the info from a few bullets up.
    - turn lucene indexing on if you want it, you probably do. Search for "enable fulltext search with lucene" and uncomment
- Then run these scripts.
  - bin/install.sh
    - fetches the HAPI CLI and a ROOT.war of the server
  - config/start-hapi.sh
    - starts the server
  - bin/loaders.sh
    - downloads and loads the vocabularies ??

## Directories here:
- bin
  - docker-compose.yaml for running the server from a Docker container.
  - env.sh and profile.sh for setting up functions and variables in the environment. env.sh is sourced by the scripts, and profile.sh is stuff that should be in users' ~/.bash_profile or similar. 
  - pgdata winds up here because its where I start docker-compose from.
  - install.sh downloads the HAPI CLI.
- ontology_cache Configured with git lfs for large files, has the files that need a login to download: Snomed, Loinc and ICD.
- loaders Contains build.sh scripts to convert OWL to FHIR, and load.sh to load to the FHIR server.
- config This is for the systemd scripts.
- hapi Contains the Hapi CLI and related files, as well as the jpaserver-starter ROOT.war and application.yaml


##Steps:
- Running from Docker includes Postgres. Running directly requires it. Use the desktop version and note names of the db etc you create.
  - for non-Docker update the profile.sh file with you values for postgres.
- if you haven't before, git lfs install, for the big files in the ontology cache. You'll know you need it, if they are ridiculously small.
  - if you've already cloned the repo, the files in ontology_cache will be too small. Re-download each with git lfs pull <file>
- cd bin
- run install.sh to get the CLI and the server
- source profile.sh  to pick up environment variables that start with PG_ that mirror the PG variables from postgres that don't have underscores.
    - These are used in the application.yaml. I'm not sure why they are different. This may change.
- start the serverby running config/start-hapi.sh
  - ==> server should come up on port 8080
- download, convert and load the data by running each of the scripts in the loaders directory. The script bin/loaders.sh does this.

##How-to Tasks
- modifying the application.yaml ?
- modifying the server configuration (in applicatio.yaml???)

##Debugging
- The root war has a 2-step build process. You'll get certain errors if you have the product of the first step only.
  - "2022-11-09 09:15:04.758 [main] ERROR o.s.boot.SpringApplication [SpringApplication.java:830] Application run failed"
  - "Caused by: org.springframework.context.ApplicationContextException: Unable to start ServletWebServerApplicationContext due to missing ServletWebServerFactory bean."
  - The bigger war file includes tomcat jars:
    - ./WEB-INF/lib/jackson-datatype-jdk8-2.13.2.jar
    - ./WEB-INF/lib/jackson-module-parameter-names-2.13.2.jar
    - ./WEB-INF/lib/tomcat-embed-core-9.0.62.jar
    - ./WEB-INF/lib/tomcat-embed-el-9.0.62.jar
    - ./WEB-INF/lib/tomcat-embed-websocket-9.0.62.jar
  - you can check with this command. No ouptut means you don't have those jars. Bad news.  jar tvf ROOT.war.save | grep tomcat-embed
  - to build it properly, you need to use spring-boot's repackage target: (I think)
    - mvn clean package spring-boot:repackage -Pboot && java -jar target/ROOT.war
    - It's crazy because just the "mvn package" command builds both ROOT.war and ROOT.war.original, making it look like some kind of repackaging is ogoing on. There may be, but it's not sufficient.
- database errors may have to do with the local postrgres server not being up, or the environment variables not being set right


##TODO:
- fhir-owl is throwing an error about a hex-binary converter when it does Mondo
- lucene search doesn't work with this set of scripts yet TODO
- reconcile env.sh and profile.sh
- I have not tested the systemd integration
- Where is the input for the 0140 OMOP stuff? I've read the code about tearing apart the file name as a source of metadata for the possibly multiple input files, but I have no idea where they are. The server has some. I have no idea the provenance.
- snappy enough on azuer?
  - ./timsts/loaders/0140_put_omop_codesystems/CodeSystem-CPT4-2021.Release.json
  - ./timsts/loaders/0140_put_omop_codesystems/hold/ICD10WHO-unknown-version.json
  - ./timsts/loaders/0140_put_omop_codesystems/hold/OMOP.Gender-unknown-version.json
  - ./timsts/loaders/0140_put_omop_codesystems/hold/ICD9Proc-ICD9CM.v32.master.descriptions.json
  - ./timsts/loaders/0140_put_omop_codesystems/hold/HCPCS-2020.Alpha.Numeric.File.json
  - ./timsts/loaders/0140_put_omop_codesystems/hold/RxNorm-20220307.json
  - ./timsts/loaders/0140_put_omop_codesystems/hold/ICD9CM-v32.master.descriptions.json
  - ./timsts/loaders/0140_put_omop_codesystems/hold/OMOP.Extension-20220622.json
  - ./timsts/loaders/0140_put_omop_codesystems/hold/ICD10PCS-2021.json
  - ./timsts/loaders/0140_put_omop_codesystems/hold/SNOMED.Veterinary-20190401.json
  - ./timsts/loaders/0140_put_omop_codesystems/hold/OMOP.Ethnicity-unknown-version.json
  - ./timsts/loaders/0140_put_omop_codesystems/hold/ICD10CM-FY2022.code.descriptions.json
  - ./timsts/loaders/0140_put_omop_codesystems/hold/OMOP.Race.and.Ethnicity-unknown-version.json



# get an application.yaml file from the downloaed release, to then modify with local database connection info
# jar xvf ROOT.war WEB-INF/classes/application.yaml
 
# and BTW, have a look at the top of the pom.xml in that ROOT.war to verify it's release version
#  jar   xvf ROOT.war META-INF/maven/ca.uhn.hapi.fhir/hapi-fhir-jpaserver-starter/pom.xml

Another useful trick to find where a server came up is: lsof -i -P -n
