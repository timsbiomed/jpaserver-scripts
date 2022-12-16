#!/bin/bash
#url=http://localhost:$PORT/fhir/
url=http://20.119.216.32:8001/fhir/
curl -i \
  --header "Content-Type: application/fhir+json; charset=UTF-8" \
  --header "Accept-Charset: utf-8"\
  --header "User-Agent: HAPI-FHIR/5.0.0 (FHIR Client; FHIR 4.0.1/R4; apache)"\
  --request DELETE \
  --output delete_codesystem.txt \
  $url/CodeSystem/19152
#  $url/CodeSystem/903
echo $?
