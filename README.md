# jpaserver-scripts (private)
scripts to start and config the hapi-fhir-jpaserver-starter

This is a **private** repo so we don't have to sweat leaving passwords or data in here.

The reason for putting into git is so we can easily adapt this to laptop use.
I'm on macos, which doesn't have systemd. No attempt to address Windows here yet.
On mac, the plan is to use Docker on a -Pboot build ROOT.war. On mac, I tried to run the war
directly, with either jetty or tomcat as servlet containers to no avail. 

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
- lucene search doesn't work with this set of scripts yet TODO
- reconcile env.sh and profile.sh
- I have not tested the systemd integration
- Where is the input for the 0140 OMOP stuff? I've read the code about tearing apart the file name as a source of metadata for the possibly multiple input files, but I have no idea where they are. The server has some. I have no idea the provenance.
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
