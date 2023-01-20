#!/usr/bin/env bash

python3 -m venv venv

source venv/bin/activate

python3 -m pip install poetry

git clone  https://github.com/INCAtools/ontology-access-kit.git
cd ontology-access-kit

# seems to be merged to main already?? that branch doesn't exist, and fhir-updates-2's commit is in main
##git checkout origin/fhir-updates

poetry shell
poetry install

