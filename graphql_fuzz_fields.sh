#!/bin/bash

# graphql_fuzz_fields.sh - Fuzz exposed queries and objects for unauthenticated access
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
echo "    GraphQL Red Team Toolkit - Unauthenticated Field Fuzzer"
echo -e "${RESET}"

read -p "[+] Enter GraphQL endpoint URL: " ENDPOINT

if [ ! -f "schema_dump.json" ]; then
    echo -e "${RED}[!] schema_dump.json not found. Run graphql_enum_schema.sh first.${RESET}"
    exit 1
fi

> fuzz_hits.txt

echo -e "${YELLOW}[>] Fuzzing all fields in OBJECT types...${RESET}"

# Grab object types and fields
jq -r '.data.__schema.types[] | select(.kind == "OBJECT") | {type: .name, fields: [.fields[]?.name]} | @base64' schema_dump.json | \
while read -r encoded; do
    decoded=$(echo "$encoded" | base64 --decode)
    type=$(echo "$decoded" | jq -r '.type')
    for field in $(echo "$decoded" | jq -r '.fields[]'); do

        QUERY=$(jq -n --arg q "{ $type { $field } }" '{query: $q}')

        RESPONSE=$(curl -s -X POST "$ENDPOINT" \
            -H "Content-Type: application/json" \
            -d "$QUERY")

        if echo "$RESPONSE" | grep -q 'data'; then
            echo -e "${GREEN}[+] ACCESSIBLE:${RESET} $type → $field"
            echo "$type.$field" >> fuzz_hits.txt
        elif echo "$RESPONSE" | grep -q 'error'; then
            echo -e "${RED}[-] Blocked:${RESET} $type → $field"
        else
            echo -e "${YELLOW}[?] Unexpected:${RESET} $type → $field"
        fi

    done

done

echo -e "\n${YELLOW}[>] Fuzzing complete. Results saved to fuzz_hits.txt${RESET}"
