#!/bin/bash

_LAMBDA_FUNCTION_ARN="${_LAMBDA_FUNCTION_ARN:?You need to set _LAMBDA_FUNCTION_ARN}"
_AWS_SECRET_ACCESS_KEY="${_AWS_SECRET_ACCESS_KEY:?You need to set _AWS_SECRET_ACCESS_KEY}"
_AWS_ACCESS_KEY_ID="${_AWS_ACCESS_KEY_ID:?You need to set _AWS_ACCESS_KEY_ID}"
_AWS_DEFAULT_REGION="${_AWS_DEFAULT_REGION:?You need to set _AWS_DEFAULT_REGION}"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/deploy-common.sh"

local BUILDPACK_DIR="${DIR}"
local OUTPUT_DIR="/tmp/lambda/"
local OUTPUT_FILE="/tmp/lambda.zip"

echo "Copying source to temporary location"
mkdir -p "${OUTPUT_DIR}"
cp -R ~/* "${OUTPUT_DIR}"

retrieveProperties "${OUTPUT_DIR}env.properties"

echo "Zipping the lambda code"
chmod -R a+rwx "${OUTPUT_DIR}"
cd "${OUTPUT_DIR}"
zip -rX "${OUTPUT_FILE}" *
cd -

deployLambda "${OUTPUT_FILE}"

