#!/bin/bash

PROPERTIES_FILE="/tmp/env.properties"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILDPACK_DIR="${DIR}"
OUTPUT_FILE=`mktemp /tmp/lambda.XXXXX`

echo "Retrieving properties"
printenv | grep -v "^_.*" | sed -e 's/^\([^\=]*\)=\(.*\)$/\1=\"\2\"/' > "${PROPERTIES_FILE}"

echo "Putting properties into jarfile"
${BUILDPACK_DIR}/properties-weaver/weave.sh "${_DEPLOY_LAMBDA_INPUT_FILE}" "${PROPERTIES_FILE}" "${OUTPUT_FILE}" 

echo "Deploying lambda"
# AWS_ACCESS_KEY_ID="${_DEPLOY_LAMBDA_AWS_ACCESS_KEY_ID}" AWS_SECRET_ACCESS_KEY="${_DEPLOY_LAMBDA_AWS_SECRET_ACCESS_KEY}" AWS_DEFAULT_REGION="${_DEPLOY_LAMBDA_AWS_DEFAULT_REGION}" ${DIR}/.heroku/python/bin/aws update-function --function-name "${_DEPLOY_LAMBDA_FUNCTION_NAME}" --zip-file "fileb://${OUTPUT_FILE}"


