#!/bin/sh -e

if [ $# -lt 1 ]; then
    echo "Usage:\n  $0 <team-number>"
    exit 1
fi

TEAM_NUMBER=$1

TOKEN_FILE=${HOME}/.Renviron
TOKEN=$(cat ${TOKEN_FILE} | grep TEMPO_KEY | sed 's/TEMPO_KEY=//' | sed 's/"//g')

if [ ! -f ${TOKEN_FILE} ]; then
    echo "${TOKEN_FILE} is missing"
    exit 1
fi

if [ -z "${TOKEN}" ]; then
    echo "${TOKEN_FILE} does not seem to contain any TEMPO_TOKEN"
    exit 1
fi


curl -s -H "Authorization: Bearer ${TOKEN}" "https://api.tempo.io/core/3/worklogs/team/${TEAM_NUMBER}?from=2021-09-25&to=2021-10-01" | jq '.'
