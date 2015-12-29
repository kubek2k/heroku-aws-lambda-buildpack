#!/bin/bash

if [ $# -lt 3 ]; then
    echo "$0 <input_jar_file> <properties_file> <output_jar_file>"
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INPUT_FILE="$1"
PROPERTIES_FILE="$2"
OUTPUT_FILE="$3"

${DIR}/../maven/bin/mvn -f "${DIR}/weave-pom.xml" antrun:run -DinputFile="${INPUT_FILE}" -DoutputFile="${OUTPUT_FILE}" -DpropertiesFile="${PROPERTIES_FILE}"

