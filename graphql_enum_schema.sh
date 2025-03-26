#!/bin/bash

# graphql_enum_schema.sh - Reusable GraphQL introspection scanner
# Author: Zane Anderson

# Colors
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
RESET="\033[0m"

# Banner
echo -e "${BLUE}"
echo "   ____                 _           _  __      __      _     _ _   "
echo "  / ___| ___   ___   __| | ___ _ __(_)/ _| ___ / _| ___| |__ (_| |_ "
echo " | |  _ / _ \\ / _ \\ / _\` |/ _ \\ '__| | |_ / _ \\ |_ / __| '_ \\| | __|"
echo " | |_| | (_) | (_) | (_| |  __/ |  | |  _|  __/  _\\__ \\ | | | | |_ "
echo "  \\____|\\___/ \\___/ \\__,_|\\___|_|  |_|_|  \\___|_| |___/_| |_|_|\\__|"
echo "   GraphQL Red Team Toolkit - Schema Introspection Scanner"
echo -e "${RESET}"

if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage:${RESET} $0 <GraphQL_Endpoint_URL>"
    exit 1
fi

ENDPOINT="$1"
OUTPUT="schema_dump.json"

INTROSPECTION_QUERY='{ "query": "{ __schema { types { name kind fields { name type { name kind ofType { name kind } } } } } }" }'

echo -e "${YELLOW}[>] Running introspection on${RESET} $ENDPOINT"

RESPONSE=$(curl -s -X POST "$ENDPOINT" \
    -H "Content-Type: application/json" \
    -d "$INTROSPECTION_QUERY")

if echo "$RESPONSE" | jq . >/dev/null 2>&1; then
    echo "$RESPONSE" | jq . > "$OUTPUT"
    echo -e "${GREEN}[+] Schema saved to:${RESET} $OUTPUT"
else
    echo -e "${RED}[!] Invalid or blocked response from target. No schema dumped.${RESET}"
    echo "$RESPONSE"
fi
