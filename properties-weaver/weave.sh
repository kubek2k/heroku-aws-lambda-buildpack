#!/bin/bash

if [ $# -lt 3 ]; then
    echo "$0 <input_jar_file> <properties_file> <output_jar_file>"
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INPUT_FILE="$1"
PROPERTIES_FILE="$2"
OUTPUT_FILE="$3"

cp "${INPUT_FILE}" "${OUTPUT_FILE}"
cp "${PROPERTIES_FILE}" /tmp/env.properties
jar uf "${OUTPUT_FILE}" -C /tmp env.properties
