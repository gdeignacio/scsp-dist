#!/bin/bash
#### Description: Build and deploy from source
#### Written by: Guillermo de Ignacio - gdeignacio@fundaciobit.org on 04-2021

###################################
###   DEPLOY MVN UTILS          ###
###################################

echo ""
PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
echo "Project path at $PROJECT_PATH"
echo ""
echo "[$(date +"%Y-%m-%d %T")] Build and deploy project..."
echo ""

source $PROJECT_PATH/bin/loadenv.sh

echo off
if [[ -f help.txt ]]
then
  cat help.txt
else
  echo "help.txt no existe"
fi

POM=$APP_POM_FILE

if [[ -f "$POM" ]]
then
    echo "Compiling $POM"
    env mvn -f $POM -DskipTests $@ install --settings $PROJECT_PATH/builds/maven-dist/maven/conf/settings.xml
fi

SAR=$SAR_POM_FILE

if [[ -f "$SAR" ]]
then
    echo "Compiling $SAR"
    env mvn -f $SAR -DskipTests $@ install --settings $PROJECT_PATH/builds/maven-dist/maven/conf/settings.xml

fi


if [ $? == 0 ]; then
  if [ "$JBOSS_DEPLOY_DIR" == "" ];  then

    echo  =================================================================
    echo    Definex la variable d\'entorn JBOSS_DEPLOY_DIR apuntant al
    echo    directori de deploy del JBOSS  i automaticament s\'hi copiara
    echo    l\'ear generat.
    echo  =================================================================
  
  else
  
    echo on
    echo --------- COPIANT EAR ---------


    if [[ -f "$EAR_FILE" ]]; then
      echo "Copying $EAR_FILE to $JBOSS_DEPLOY_DIR"
      cp $EAR_FILE $JBOSS_DEPLOY_DIR
    fi
    
    if [[ -f "$SAR_FILE" ]]; then
      echo "Copying $SAR_FILE to $JBOSS_DEPLOY_DIR"
      cp $SAR_FILE $JBOSS_DEPLOY_DIR
    fi

    if [[ -f "$DS_FILE" ]]; then
      echo "Copying $DS_FILE to $JBOSS_DEPLOY_DIR"
      cp $DS_FILE $JBOSS_DEPLOY_DIR
    fi
  
  
  fi
fi
