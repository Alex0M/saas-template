#!/bin/bash



envFile=".env"

if [ -f "$envFile" ]
then
  . $envFile

  GROUP_ID=com.secourse.xaas
  ARTIFACT_ID=service
  BUNDLE_VERSION=17.11.0-SNAPSHOT
  BUNDLE_PACKAGING="jar"
  ARTIFACT="${GROUP_ID}.${ARTIFACT_ID}-${BUNDLE_VERSION}.${BUNDLE_PACKAGING}"
  PATH_TO=./service/target

  echo "Upload artifact ${ARTIFACT} into Nexus snapshot repository"

  mvn --settings ./settings.xml deploy:deploy-file \
    -DrepositoryId=saas-template \
    -Durl="http://${NEXUS_HOST}/repository/${NEXUS_REPO}" \
    -Dfile="${PATH_TO}/${ARTIFACT}" \
    -DgroupId="${GROUP_ID}" \
    -DartifactId="${ARTIFACT_ID}" \
    -Dversion="${BUNDLE_VERSION}" \
    -Dpackaging="${BUNDLE_PACKAGING}" \
    -DgeneratePom=true \
    -DuniqueVersion=false

else
  echo "'$envFile' not found."
  echo "copy '.env.template' to '$envFile' and update it according to your environment"
fi
