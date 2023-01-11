#!/bin/bash
## =======================================================================================
# File:     feroxbuster-batch-for-htb.sh
# Author:   Cashiuus
# Created:  19-Nov-2021     Revised:
#
#   Place file in /usr/local/bin or in ~/.locain/bin and chmod u+x <file>
#   Then, this file will be in path to use as a wrapper in place of remmebering
#   all the rediculous switches needed for standard website dir busting
#
## =======================================================================================
## ==========[  TEXT COLORS  ]============= ##
GREEN="\033[01;32m"     # Success
YELLOW="\033[01;33m"    # Warnings/Information
RED="\033[01;31m"       # Issues/Errors
BLUE="\033[01;34m"      # Heading
ORANGE="\033[38;5;208m" # Debugging
PURPLE="\033[01;35m"    # Other
GREY="\e[90m"           # Subdued Text
BOLD="\033[01;01m"      # Highlight
RESET="\033[00m"        # Normal


### ===============[ Init & Process Arguments ]============== ###
#APP_ARGS=$@
if [[ $# -eq 0 ]]; then
    echo -e "   Usage: $0 <URL>\n\n"
    exit 1
fi
if [[ ! $(which feroxbuster) ]]; then
    echo -e "[ERROR] feroxbuster is not installed or not in path, try again."
    exit 1
fi

TARGET="$1"

GIT_HOME="${HOME}/git"
CUR_DIR=$(pwd)
MY_WORDLIST="${HOME}/htb/toolkit/cash-wordlist.txt"

USERAGENT='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36'
POSCODES="200,204,301,302,307,403,500"
EXTENSIONS="txt,html,php,asp,aspx,jsp"
THREADS="10"


# Ensure we have seclists already in our standard git directory
[[ ! -d "${GIT_HOME}" ]] && mkdir -p "${GIT_HOME}" 2>/dev/null

if [[ ! -d "${GIT_HOME}/seclists" ]]; then
    echo -e "${GREEN}[*]${RESET} You don't have seclists repo cloned. Doing that now..."
    cd "${GIT_HOME}"
    git clone https://github.com/danielmiessler/SecLists seclists
else
    cd "${GIT_HOME}/seclists"
    git pull
    cd "${CUR_DIR}"
fi


### Nikto
echo -e "${GREEN}[*]${RESET} Beginning NIKTO scans against target $TARGET"
nikto -host "${TARGET}" -useragent "${USERAGENT}" -output "nikto-results.txt"
exit 0

### Feroxbuster
echo -e "${GREEN}[*]${RESET} Beginning FEROXBUSTER scans against target $TARGET"

# 1. my custom wordlist first
feroxbuster -u "${TARGET}" -a "${USERAGENT}" -e -k -t "${THREADS}" \
    -w "/usr/share/seclists/Discovery/Web-Content/common.txt" \
    --auto-bail -o ferox-results-list_mycustom.txt

# 2. common
feroxbuster -u "${TARGET}" -a "${USERAGENT}" -e -k -t "${THREADS}" \
    -w "/usr/share/seclists/Discovery/Web-Content/common.txt" \
    --auto-bail -o ferox-results-list_common.txt

# 3. PHP specific
feroxbuster -u "${TARGET}" -a "${USERAGENT}" -e -k -t "${THREADS}" \
    -w "/usr/share/seclists/Discovery/Web-Content/PHP.fuzz.txt" \
    --auto-bail -o ferox-results-list_phpfuzz.txt

# 4. PHP specific
feroxbuster -u "${TARGET}" -a "${USERAGENT}" -e -k -t "${THREADS}" \
    -w "/usr/share/seclists/Discovery/Web-Content/Common-PHP-Filenames.txt" \
    --auto-bail -o ferox-results-list_phpcommon.txt

# 5. directory-list-2.3-medium
feroxbuster -u "${TARGET}" -a "${USERAGENT}" -e -k -t "${THREADS}" \
    -w "/usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt" \
    --auto-bail -o ferox-results-list_medium.txt




# -------------------------------------------
#       End of actual script
exit 0
# -------------------------------------------

    # -e enables extracting links from response body and adding those to queue to scan too (default: false)
    # -k disabled TLS cert validation

    # --auto-bail will stop scanning when too many errors
    # --auto-tune will automatically lower scan rate when too many errors (can't use these 2 together)

    # -d, --depth #     default recursion depth is 4
    # -x to specify a list of space-separate extensions
    # --rate-limit #    default 0 (no limit), specify # req per second per directory
    # --scan-limit #    default 0, specify # concurrent scans
    # -t, --threads #   default 50
    # -T, --timeout #   deafult 7, # of seconds before request times out

    # --dont-scan <url> URL(s) to exclude from recursion/scans (e.g. in case --extract-links sees it)


## ===================================================================================== ##
#   Wordlist Reference

#   Wordcount       File
#   ---------       -----
#               directory-list-2.3-big.txt
#   220,560         directory-list-2.3-medium.txt
#   87,664          directory-list-2.3-small.txt
#   4,660           common.txt
#   37,042          raft-large-files.txt
#               raft-large-directories.txt
#               quickhits.txt
#
#               LinuxFileList.txt
#               Common-DB-Backups.txt
#               Common-PHP-Filenames.txt
#               PHP.fuzz.txt
#               Apache.fuzz.txt
#               apache.txt
#               CGIs.txt

# Notes on Wordlists from my use
#   common.txt doesn't have "cdn-cgi" in it
#



# Global gobuster commands
#   -z  no progress
#   -o  output file to write results to
#   -q  quiet
#   -t  threads (default 10)
#   -w  wordlist to use
#
# dir specific gobuster commands
#   Default timeout is 10 seconds
#
#   -a  user agent
#   -u  target to hit
#
#   -f  add / to each request
#   -e  expanded mode, print full URLs
#   -x  file extensions to search for
#   -r  enable following redirects
#   -H  specify headers, one per arg, can have multiple args
#   -k  skip SSL cert verification
#   -n  don't print status codes
#
#   -s  positive status codes that determine valid result
#           (Default: 200,204,301,302,307,401,403)
#   -b  negative status codes (blacklist)
#           (Default: none)
#
#   -U  username for basic auth
#   -P  password for basic auth

#   --wildcard  enable wildcard responses
## ===================================================================================== ##
