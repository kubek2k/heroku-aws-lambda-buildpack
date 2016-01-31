#!/bin/bash

_LAMBDA_FUNCTION_ARN="${_LAMBDA_FUNCTION_ARN:?You need to set _LAMBDA_FUNCTION_ARN}"
_AWS_SECRET_ACCESS_KEY="${_AWS_SECRET_ACCESS_KEY:?You need to set _AWS_SECRET_ACCESS_KEY}"
_AWS_ACCESS_KEY_ID="${_AWS_ACCESS_KEY_ID:?You need to set _AWS_ACCESS_KEY_ID}"
_AWS_DEFAULT_REGION="${_AWS_DEFAULT_REGION:?You need to set _AWS_DEFAULT_REGION}"

function retrieveProperties() {
    local OUTPUT_FILE="$1"
    echo "Retrieving properties"
    printenv | grep -v "^_.*" | sed -e 's/^\([^\=]*\)=\(.*\)$/\1=\2/' > "${OUTPUT_FILE}"
}

function deployLambda() {
    local LAMBDA_FILE="$1"
    echo "Deploying lambda from file ${LAMBDA_FILE}"
    AWS_ACCESS_KEY_ID="${_AWS_ACCESS_KEY_ID}" AWS_SECRET_ACCESS_KEY="${_AWS_SECRET_ACCESS_KEY}" AWS_DEFAULT_REGION="${_AWS_DEFAULT_REGION}" ${DIR}/../.heroku/python/bin/aws lambda update-function-code --function-name "${_LAMBDA_FUNCTION_ARN}" --zip-file "fileb://${LAMBDA_FILE}"
}
