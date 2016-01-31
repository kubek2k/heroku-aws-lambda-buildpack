#!/bin/bash

function retrieveProperties() {
    OUTPUT_FILE="$1"
    echo "Retrieving properties"
    printenv | grep -v "^_.*" | sed -e 's/^\([^\=]*\)=\(.*\)$/\1=\2/' > "${OUTPUT_FILE}"
}
