#!/bin/bash

_LAMBDA_JAR_FILE="${_LAMBDA_JAR_FILE:?You need to set _LAMBDA_JAR_FILE}"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/deploy-common.sh"

PROPERTIES_FILE="/tmp/env.properties"
BUILDPACK_DIR="${DIR}"
OUTPUT_FILE="/tmp/lambda.jar"

retrieveProperties "${PROPERTIES_FILE}"

echo "Putting properties into jarfile"
${BUILDPACK_DIR}/properties-weaver/weave.sh "${DIR}/../${_LAMBDA_JAR_FILE}" "${PROPERTIES_FILE}" "${OUTPUT_FILE}" 

deployLambda "${OUTPUT_FILE}"
