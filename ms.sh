#!/usr/bin/env bash
set -euo pipefail

CURL_CMD="curl -skL "
URL_SEARCH="https://search.maven.org/solrsearch/select?"

QUERY="${1:-}"

if [ -z "$QUERY" ]; then
    echo "Provide a query string to search maven central" 1>&2
    exit 127
fi

IFS=':' read -ra VAL <<< "$QUERY"
GROUP="${VAL[0]}"
ARTIFACT=${VAL[1]:-}

if [ -n "$ARTIFACT" ]; then
    QUERY="g:${GROUP}%20AND%20a:${ARTIFACT}"
fi

RESULT=$($CURL_CMD "${URL_SEARCH}q=${QUERY}")

# Format result
JQ_FORMAT="{dep: .response.docs[].id, ver: .response.docs[].latestVersion} | join(\" \")"
echo "$RESULT" | jq -r "${JQ_FORMAT}" | sort
