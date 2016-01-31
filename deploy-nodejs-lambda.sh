#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/deploy-common.sh"

BUILDPACK_DIR="${DIR}"
OUTPUT_DIR="/tmp/lambda/"
OUTPUT_FILE="/tmp/lambda.zip"

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

