#!/bin/bash

PROPERTIES_FILE="/tmp/env.properties"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILDPACK_DIR="${DIR}"
OUTPUT_FILE="/tmp/lambda.jar"

echo "Retrieving properties"
printenv | grep -v "^_.*" | sed -e 's/^\([^\=]*\)=\(.*\)$/\1=\"\2\"/' > "${PROPERTIES_FILE}"

echo "Putting properties into jarfile"
${BUILDPACK_DIR}/properties-weaver/weave.sh "${DIR}/../${_LAMBDA_JAR_FILE}" "${PROPERTIES_FILE}" "${OUTPUT_FILE}" 

echo "Deploying lambda"
AWS_ACCESS_KEY_ID="${_AWS_ACCESS_KEY_ID}" AWS_SECRET_ACCESS_KEY="${_AWS_SECRET_ACCESS_KEY}" AWS_DEFAULT_REGION="${_AWS_DEFAULT_REGION}" ${DIR}/../.heroku/python/bin/aws update-function --function-name "${_LAMBDA_FUNCTION_NAME}" --zip-file "fileb://${OUTPUT_FILE}"


