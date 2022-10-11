# jpaserver-scripts (private)
scripts to start and config the hapi-fhir-jpaserver-starter

This is a **private** repo so we don't have to sweat leaving passwords in here.

The reason for putting into git is so we can easily adapt this to laptop use.
I'm on macos, which doesn't have systemd. My focus there is on the scripts 
that systemd would call. I'm using a Postgres app for example.

Windows is another question.


# DATA
In the loaders directory are directoris for different vocabularies.
Each has a load.sh and one or more datafiles. Other files are flags
to the scripts so you don't load when you already have.

The loaders tree contains the vocabulary files as well (not kept in git!)

- 0000_post_template.off:
- 0000_put_template.off:
- 0100_snomed: SnomedCT_USEditionRF2_PRODUCTION_20210901T120000Z.zip
- 0110_loinc: Loinc_2.72.zip
- 0120_icd10: icd10cm_tabular_2022.xml
- 0130_omop_vocabularies_hapi_csv.off:  RxNorm.Extension_20220615_hapi_csv.zip
- 0140_put_omop_codesystems: CodeSystem-CPT4-2021.Release.json
- 0160_put_mondo: CodeSystem-mondo.json


# Running locally on a Mac without the benefit of systemd or similar.
- install and start a desktop postgres. 
    - Collect the environment variables: PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD. Make them available to these scripts in PG_HOST, PG_PORT, and password in PG_POSTGRES
- collect the data files above
- collect some code and configs
  - hapi.jar
    - build a hapi-fhir-jpaserver-starter ROOT.war and copy it into the hapi directory. Either name it hapi.jar or create a symlink to that name. 
  - application.yaml
  - hapi-fhir-cli.jar 


