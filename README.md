# jpaserver-scripts (public)
scripts to start and config the hapi-fhir-jpaserver-starter
- assumes a companion repo, ontology_cache is in the same directory as this repo.

This is NOT a **private** repo anymore so we DO have to sweat leaving passwords or data in here.

The reason for putting into git is so we can easily adapt this to laptop use, and so we can have a reproducible process for setting up and loading the server.
I'm on macos, which doesn't have systemd. No attempt to address Windows.

For now, scripts here install the following versions:
 - hapi-fhir-6.1.3-cli from http://github.com/hapifhir
 - v5.7.0 of the jpaserver-starter ROOT war from http://github.com/HOT-Ecosystem/hapi-fhir-jpaserverstarter
 - fhir-owl 1.1.0 from github.com/HOT-Ecosystem/fhir-owl.
I tried 5.5 and had difficulty. I also tried 6.0.1 though that path is not fully explored.

Other code may be loaded as part of the `loaders/*/build.sh` scripts.

In the following list of steps, a line starting with a `$` is one to be entered on the command line. Don't repeat the `$` sign. It's mean as the prompt you see there.

## Defaults
The defaults are set up to run against a postgres database on the localhost, called hapifhir (that you create in a step below) installed on macos with postgres app,
on port 8001, with lucene enabled and a number of ontologies loaded.

## Steps
### Set up, installation, and deployment
- Install PostgreSQL if you want to use it. 
  - I use https://postgresapp.com/ on macos.
  - For postgresapp, create a server. I call mine hapifhir, but don't confuse it with the database in the next step.
  - Create a database called hapifhir, with createdb.
    - `$ createdb hapifhir`
- Install Git Large File Support (git lfs)
  - `$ git lfs install`
  - if you've already cloned the repo, the files in ontology_cache will be too small. Re-download each with
    - `$ git lfs pull <file>`
  - The point of the `ontology_cache/` ~directory~ repository is to cache, not to definitively store, vocabularies that aren't easily cURLed from the 'net.
- Export scripts and configure .  In a terminal window with a bash or z-shell, from the top-level directory of the git repo where you found this file:
  - `$ git export master > jpaserver-scripts.tar `
  - copy that file to the machine or place you want to deploy on
  - make a directory for its contents: 
    - `$mkdir jpaserver-scripts; cd jpaserver-scripts`
  - expand it: 
    - `$ tar xvf ../jpaserver-scripts.tar`
  - edit bin/profile.sh to have connection info to your postgres instance if you're doing that. H2 doesn't require this. 
    - for postgresapp:
      - `PGHOST=localhost`
      - `PGUSER=<user>`
      - `PGPASSWORD=it_matters_not`
      - `PGPORT=5432`
      - `PGDATABASE=hapifhir`
      - The username will be either postgress, or the your username on  your mac. The password isn't used by postgresapp and does not matter. Note the database value. You'll create it later, if it doesn't exist.
    - also edit the bin/profile.sh file and set the variable HAPI_R4 to the port you want the HAPI server to run on. This number will be used again in a step below.
  - create the database
    - `$createdb hapifhir`
  - choose your `application.yaml` file. 
  - edit `hapi/application.yaml` to set some things
    - the port you want to run on. Look for "server: port:" near the top of the file, make sure it's different from the one used in tester near the bottom, and should be the same as used in `bin/profile.sh` for `HAPI_R4`.
        - server port is often 8000 ?????
        - testeer???
    - connection info to your postgres instance. For postgres, this should use the PG* variables (no underscore) set above, and the defaults are written to refer to those variables, so no action is needed.
    - Choose PostgreSQL or H2 and comment the other out with a hash character on each line.
    - Turn lucene indexing on if you want it, you probably do. Search for "enable fulltext search with lucene" and uncomment.
- Install, start and load: 
  - fetch the HAPI CLI and a `ROOT.war` of the server
    - `$ bin/install.sh`
  - `$ source profile.sh`
  - start the server
    - `$ config/start-hapi.sh`
  - reset flag files marking a vocabulary has been loaded when repeating this step. These files are the ouput of the loading process and should be consulted in case of trouble. The presence of a file ending in either "loading.txt" or "loaded.txt" file will prevent the vocabulary from being loaded.
    - `$ rm loaders/*/*.txt`
  - load the vocabularies
    - `$ bin/loaders.sh`
  - test with the Jupyter notebooks available at https://github.com/HOT-Ecosystem/TSDemoBoard
    - assuming defaults, the `BASE_URL` there should be set in accord with values here, `BASE_URL =\"http://localhost:8001/fhir/"`

### Running things manually
This project is set up to run things automatically. However, it is possible to run some things manually, which may be useful for troubleshooting.

#### OWL conversions
We are using https://github.com/incATools/ontology-access-kit/ to convert OWL to FHIR.
```sh
$ pip install oaklib
$ runoak -i OWL_PATH dump -o OUTPATH -O fhirjson
```

## Directories here:
- `bin/`
  - `env.sh` and `profile.sh` for setting up functions and variables in the environment. `env.sh` is sourced by the scripts, and profile.sh is stuff that should be in users' `~/.bash_profile` or similar. 
  - `install.sh` downloads the HAPI CLI.
- `ontology_cache/`  (repository assumed to be parallel to this one) Configured with git lfs for large files, has the files that need a login to download: Snomed, Loinc and ICD.
- `loaders/` Contains build.sh scripts to convert OWL to FHIR, and load.sh to load to the FHIR server. Some vocabularies have build.sh scripts that do basically nothing because the HAPI CLI can handle the files as the come. They exist for consistency only.
- `config/` This is for the systemd scripts, that haven't been tested recently.
- `hapi/` Contains the Hapi CLI and related files, as well as the jpaserver-starter `ROOT.war` and `application.yaml`
  - The default config in the git repo, has a symbolic link from `application.yaml` to `application_phenopackets_pg.yaml`. I lifted it from the phenopackets project so it includes that IG. Future work may provide a version without that.
  - This also seems to activate CORS, which gave me trouble last time I was on the JHU server: TBD.
  - It has lucene search enabled.
  - It has a paragraph called tester, that needs explored, explained or removed: TBD.

## TODO
- What is the Terminology block you see at the bottom of some application.yaml files? see the app.6.yaml file
- fhir-owl is throwing an error about a hex-binary converter when it does Mondo
- functions from env.sh should probably be part of profile.sh. Joe and Shahim like the behind the scenes and automatic nature of .env, but it was causing problems.
- I have not tested the systemd integration.
- Where is the input for the 0140 OMOP stuff? I've read the code about tearing apart the file name as a source of metadata for the possibly multiple input files, but I have no idea where they are. The server has some. I don't know the provenance.
  - `./timsts/loaders/0140_put_omop_codesystems/CodeSystem-CPT4-2021.Release.json`
  - `./timsts/loaders/0140_put_omop_codesystems/hold/ICD10WHO-unknown-version.json`
  - `./timsts/loaders/0140_put_omop_codesystems/hold/OMOP.Gender-unknown-version.json`
  - `./timsts/loaders/0140_put_omop_codesystems/hold/ICD9Proc-ICD9CM.v32.master.descriptions.json`
  - `./timsts/loaders/0140_put_omop_codesystems/hold/HCPCS-2020.Alpha.Numeric.File.json`
  - `./timsts/loaders/0140_put_omop_codesystems/hold/RxNorm-20220307.json`
  - `./timsts/loaders/0140_put_omop_codesystems/hold/ICD9CM-v32.master.descriptions.json`
  - `./timsts/loaders/0140_put_omop_codesystems/hold/OMOP.Extension-20220622.json`
  - `./timsts/loaders/0140_put_omop_codesystems/hold/ICD10PCS-2021.json`
  - `./timsts/loaders/0140_put_omop_codesystems/hold/SNOMED.Veterinary-20190401.json`
  - `./timsts/loaders/0140_put_omop_codesystems/hold/OMOP.Ethnicity-unknown-version.json`
  - `./timsts/loaders/0140_put_omop_codesystems/hold/ICD10CM-FY2022.code.descriptions.json`
  - `./timsts/loaders/0140_put_omop_codesystems/hold/OMOP.Race.and.Ethnicity-unknown-version.json`

## NOTES & Tricks
- get an application.yaml file from the downloaed release, to then modify with local database connection info
  - `jar xvf ROOT.war WEB-INF/classes/application.yaml`
- and BTW, have a look at the top of the pom.xml in that ROOT.war to verify it's release version
  -  `jar xvf ROOT.war META-INF/maven/ca.uhn.hapi.fhir/hapi-fhir-jpaserver-starter/pom.xml`
- Another useful trick to find where a server came up is: lsof -i -P -n
    - better is to use ps -aef | grep java to find the pid of the server, then
    - `lsof -i -P -n | grep <pid>`

### Debugging
- The root war has a 2-step build process. You'll get certain errors if you have the product of the first step only.
  - "2022-11-09 09:15:04.758 [main] ERROR o.s.boot.SpringApplication [SpringApplication.java:830] Application run failed"
  - "Caused by: org.springframework.context.ApplicationContextException: Unable to start ServletWebServerApplicationContext due to missing ServletWebServerFactory bean."
  - The bigger war file includes tomcat jars:
    - `./WEB-INF/lib/jackson-datatype-jdk8-2.13.2.jar`
    - `./WEB-INF/lib/jackson-module-parameter-names-2.13.2.jar`
    - `./WEB-INF/lib/tomcat-embed-core-9.0.62.jar`
    - `./WEB-INF/lib/tomcat-embed-el-9.0.62.jar`
    - `./WEB-INF/lib/tomcat-embed-websocket-9.0.62.jar`
  - you can check with this command. No ouptut means you don't have those jars. Bad news.  
    `$ jar tvf ROOT.war | grep tomcat-embed`
  - to build it properly, you need to use spring-boot's repackage target: 
    - mvn clean package spring-boot:repackage -Pboot && java -jar target/ROOT.war
    - It's crazy because just the "mvn package" command builds both ROOT.war and ROOT.war.original, making it look like some kind of repackaging is ogoing on. There may be, but it's not sufficient.
- database errors may have to do with the local postgres server not being up, or the environment variables not being set right
- server port can be tricky. 
  - it defaults to 8080, and is set by the server port field, but should not conflict (AFAICT) with the port in the tester paragraph.
  - Of course it should also not conflict with other servers, hapi (often 8080), jupyter (8888), or otherwise.
- Postgres requires a dialect class and that class must be available in the build of the ROOT.war you use. It's different for 6.x versions of the HAPI server. application.yaml files here are for 5.x
