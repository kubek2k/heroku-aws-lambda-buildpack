#!/bin/bash

if [ $# -lt 2 ]; then
    echo "$0 <input_jar_file> <properties_file>"
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INPUT_FILE="$1"
PROPERTIES_FILE="$2"
BASE_INPUT_FILE=$(basename "$INPUT_FILE")
OUTPUT_FILE="${DIR}/target/${BASE_INPUT_FILE%.jar}-with-properties.jar"

mvn -f "${DIR}/weave-pom.xml" antrun:run -DinputFile="${INPUT_FILE}" -DoutputFile="${OUTPUT_FILE}" -DpropertiesFile="${PROPERTIES_FILE}"

