#!/bin/bash

_LAMBDA_FUNCTION_ARN="${_LAMBDA_FUNCTION_ARN:?You need to set _LAMBDA_FUNCTION_ARN}"
_AWS_SECRET_ACCESS_KEY="${_AWS_SECRET_ACCESS_KEY:?You need to set _AWS_SECRET_ACCESS_KEY}"
_AWS_ACCESS_KEY_ID="${_AWS_ACCESS_KEY_ID:?You need to set _AWS_ACCESS_KEY_ID}"
_AWS_DEFAULT_REGION="${_AWS_DEFAULT_REGION:?You need to set _AWS_DEFAULT_REGION}"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILDPACK_DIR="${DIR}"
OUTPUT_DIR="/tmp/lambda/"
OUTPUT_FILE="/tmp/lambda.zip"

echo "Copying source to temporary location"
mkdir -p "${OUTPUT_DIR}"
cp -R ~/* "${OUTPUT_DIR}"

echo "Retrieving properties"
printenv | grep -v "^_.*" | sed -e 's/^\([^\=]*\)=\(.*\)$/\1=\2/' > "${OUTPUT_DIR}env.properties"

echo "Zipping the lambda code"
chmod -R a+rwx "${OUTPUT_DIR}"
cd "${OUTPUT_DIR}"
zip -rX "${OUTPUT_FILE}" *
cd -

echo "Deploying lambda"
AWS_ACCESS_KEY_ID="${_AWS_ACCESS_KEY_ID}" AWS_SECRET_ACCESS_KEY="${_AWS_SECRET_ACCESS_KEY}" AWS_DEFAULT_REGION="${_AWS_DEFAULT_REGION}" ${DIR}/../.heroku/python/bin/aws lambda update-function-code --function-name "${_LAMBDA_FUNCTION_ARN}" --zip-file "fileb://${OUTPUT_FILE}"


