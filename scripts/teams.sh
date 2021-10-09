#!/bin/sh -e

TOKEN_FILE=${HOME}/bin/tempo.token

if [ ! -f ${TOKEN_FILE} ]; then
    echo "Tempo API token is expected in"
    echo "${TOKEN_FILE}"
    exit 1
fi


curl -s -H "Authorization: Bearer $(cat ${TOKEN_FILE})" "https://api.tempo.io/core/3/teams" | jq '.results[] | .name, .id'
