#!/usr/bin/env bash
set -euo pipefail


CURL_CMD="curl -skL "
URL_SEARCH="https://search.maven.org/solrsearch/select?"

QUERY=$1
RESULT=$($CURL_CMD "${URL_SEARCH}q=${QUERY}")

# Format result
JQ_FORMAT="{dep: .response.docs[].id, ver: .response.docs[].latestVersion} | join(\" \")"
echo "$RESULT" | jq -r "${JQ_FORMAT}" | sort
