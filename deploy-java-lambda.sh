#!/bin/bash

_LAMBDA_FUNCTION_ARN="${_LAMBDA_FUNCTION_ARN:?You need to set _LAMBDA_FUNCTION_ARN}"
_LAMBDA_JAR_FILE="${_LAMBDA_JAR_FILE:?You need to set _LAMBDA_JAR_FILE}"
_AWS_SECRET_ACCESS_KEY="${_AWS_SECRET_ACCESS_KEY:?You need to set _AWS_SECRET_ACCESS_KEY}"
_AWS_ACCESS_KEY_ID="${_AWS_ACCESS_KEY_ID:?You need to set _AWS_ACCESS_KEY_ID}"
_AWS_DEFAULT_REGION="${_AWS_DEFAULT_REGION:?You need to set _AWS_DEFAULT_REGION}"

PROPERTIES_FILE="/tmp/env.properties"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILDPACK_DIR="${DIR}"
OUTPUT_FILE="/tmp/lambda.jar"

echo "Retrieving properties"
printenv | grep -v "^_.*" | sed -e 's/^\([^\=]*\)=\(.*\)$/\1=\2/' > "${PROPERTIES_FILE}"

echo "Putting properties into jarfile"
${BUILDPACK_DIR}/properties-weaver/weave.sh "${DIR}/../${_LAMBDA_JAR_FILE}" "${PROPERTIES_FILE}" "${OUTPUT_FILE}" 

echo "Deploying lambda"
AWS_ACCESS_KEY_ID="${_AWS_ACCESS_KEY_ID}" AWS_SECRET_ACCESS_KEY="${_AWS_SECRET_ACCESS_KEY}" AWS_DEFAULT_REGION="${_AWS_DEFAULT_REGION}" ${DIR}/../.heroku/python/bin/aws lambda update-function-code --function-name "${_LAMBDA_FUNCTION_ARN}" --zip-file "fileb://${OUTPUT_FILE}"


