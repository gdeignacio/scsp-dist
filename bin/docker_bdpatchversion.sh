#!/bin/bash

set -o nounset
set -o errexit

#### Description: Build from source
#### Written by: Guillermo de Ignacio - gdeignacio@fundaciobit.org on 04-2021

###################################
###   BUILD MVN UTILS           ###
###################################

echo ""
PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
echo "Project path at $PROJECT_PATH"
echo ""
echo "[$(date +"%Y-%m-%d %T")] Loading database..."
echo ""

# Taking values from .env file

source $PROJECT_PATH/bin/lib_string_utils.sh 
source $PROJECT_PATH/bin/lib_env_utils.sh

lib_env_utils.loadenv ${PROJECT_PATH}
echo ""
lib_env_utils.check_os
echo ""
lib_env_utils.check_docker
echo ""

if [[ "${DOCKER}" == "/dev/null" ]]; then
  echo "Docker not installed. Exiting"
  exit 1
fi

VERSIONS_ARRAY=(1.4.10.error 1.4.10 1.4.11)

VERSIONS_PATH=${PROJECT_PATH}/${APP_SOURCE_FOLDER}/versions

for VERSION in ${VERSIONS_ARRAY[*]}; do
  VERSION_FOLDER=${VERSIONS_PATH}/${VERSION}
  echo "Executing "$VERSION "version patch"
  if [ -d "$VERSION_FOLDER" ]; then
    # Copy section
    for FILE in $VERSION_FOLDER/*; do
      if [[ -f "$FILE" ]]; then
        echo Loading $FILE
        ${DOCKER} exec -i ${LONG_APP_NAME_LOWER}-pg psql -v ON_ERROR_STOP=1 --username ${LONG_APP_NAME_LOWER} --dbname ${LONG_APP_NAME_LOWER} < $FILE
      fi
    done
  else
    echo "${VERSION_FOLDER} not found"
  fi
done
