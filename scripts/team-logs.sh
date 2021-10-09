#!/bin/sh -e

if [ $# -lt 1 ]; then
    echo "Usage:\n  $0 <team-number>"
    exit 1
fi

TEAM_NUMBER=$1

TOKEN_FILE=${HOME}/bin/test.token

if [ ! -f ${TOKEN_FILE} ]; then
    echo "Tempo API token is expected in"
    echo "${TOKEN_FILE}"
    exit 1
fi


curl -s -H "Authorization: Bearer $(cat ${TOKEN_FILE})" "https://api.tempo.io/core/3/worklogs/team/${TEAM_NUMBER}?from=2021-09-25&to=2021-10-01" | jq '.'
