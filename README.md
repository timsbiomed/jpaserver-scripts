# jpaserver-scripts (private)
scripts to start and config the hapi-fhir-jpaserver-starter

This is a **private** repo so we don't have to sweat leaving passwords or data in here.

The reason for putting into git is so we can easily adapt this to laptop use.
I'm on macos, which doesn't have systemd. No attempt to address Windows here yet.
On mac, the plan is to use Docker on a -Pboot build ROOT.war. On mac, I tried to run the war
directly, with either jetty or tomcat as servlet containers to no avail. 

Directories here:
- bin
  - docker-compose.yaml for running the server from a Docker container.
  - env.sh and profile.sh for setting up functions and variables in the environment. env.sh is sourced by the scripts, and profile.sh is stuff that should be in users' ~/.bash_profile or similar. 
  - pgdata winds up here because its where I start docker-compose from.
  - install.sh downloads the HAPI CLI.
- ontology_cache Configured with git lfs for large files, has the files that need a login to download: Snomed, Loinc and ICD.
- loaders Contains build.sh scripts to convert OWL to FHIR, and load.sh to load to the FHIR server.
- config This is for the systemd scripts.
- hapi Contains the Hapi CLI and related files, as well as the jpaserver-starter ROOT.war and application.yaml


Steps:
- git lfs install
- if you've already cloned the repo, the files in ontology_cache will be too small. Re-download each with git lfs pull <file>
- cd bin
- source profile.sh and modify ~/.bash_profile
- start the server by running: docker compose up
  - or start the server by running config/start-hapi.sh to run directly on linux.
- download, convert and load the data by running each of the scripts in the loaders directory.
==> server should come up on port 8080

How-to Tasks
- modifying the application.yaml ?
- modifying the server configuration (in applicatio.yaml???)


TODO:
- as of this writing, the large files fail to load when running the server in Docker. The CLI checks the file size and uses a direct file read when they are larger than a certain size that SNOMED definitely violates. When running the CLI and the server on the same machine, it works. Docker is the same hardware, but the file systems look different depending on where you are. The file path sent from CLI to the server inside Docker doesn't work, and it errors out. 
- There are two solutions. One is a new flag on CLI that lets one specify a much larger limit. This isn't too bad, because you don't have a slow network between the CLI and the server. SNOMED is so big, you run into some memory issues.
- The second, TBD,  is to set up shared files in the Dockerfile, so the file path that the CLI tells the server to use is available to the server and works. I haven't cracked that just yet. Stay tuned.


