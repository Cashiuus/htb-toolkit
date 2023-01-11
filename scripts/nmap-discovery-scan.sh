#!/bin/bash
## =======================================================================================
# File:     nmap-discovery-scan.sh
# Author:   Cashiuus
# Created:  12-May-2021     Revised:    02-Nov-2022
#
#
#
#
## =======================================================================================
__version__="0.2.0"
__author__="Cashiuus"
## ==========[ TEXT COLORS ]============= ##
GREEN="\033[01;32m"     # Success
YELLOW="\033[01;33m"    # Warnings/Information
RED="\033[01;31m"       # Issues/Errors
BLUE="\033[01;34m"      # Heading
ORANGE="\033[38;5;208m" # Debugging
PURPLE="\033[01;35m"    # Other
GREY="\e[90m"           # Subdued Text
BOLD="\033[01;01m"      # Highlight
RESET="\033[00m"        # Normal
## =============[ CONSTANTS ]============= ##
DATE=$(date +%F)
APP_PATH=$(readlink -f $0)
APP_BASE=$(dirname "${APP_PATH}")


# -- Edit These Before Running Script --
OUTPUT_DIR="${APP_BASE}"
SCOPE_FILE="${OUTPUT_DIR}/scope.txt"
PROJECT_NAME="nmap_discovery_scan"


# Custom Top 'n' Port Lists Tailored for Internal Network Scanning
#       Nmap's top 'n' ports are based on Internet-scanning analysis, and
#       don't always work for what we see inside the network.

# NOTE: Printer ports: 515 (LPD), 631 (HTTP, IPP), 9100

# Top List all ports we want to scan during initial enumeration
TOP_TCP_INTERNAL='21,22,23,25,80,88,110,135,139,389,443,445,636,1433,3306,3389,5432,5900,5985,8000,8008,8080,8081,8443,27019'

TOP_UDP_INTERNAL='53,67,68,69,123,137,161,162,500,623,1194,5060,10161,10162,17185'
#CUSTOM_XSL="${APP_BASE}/../config/nmap-x.xsl"




if [[ ! -d "${OUTPUT_DIR}" ]]; then
    echo -e "[ERR] Your output directory does not exist, creating it now..."
    mkdir -p "${OUTPUT_DIR}"
fi


# Discovery workflow
#sudo nmap -v -Pn -sS -p "$TOP_20_TCP_INTERNAL" --reason --open "${TARGET}" -oA "nmap-discovery-tcp-20ports-${TARGET}"

# Example discovery to extract IPs of live hosts:
#nmap -sn 192.168.0.0/24 | awk '/Nmap scan/{gsub(/[()]/,"",$NF); print $NF > "nmap_scanned_ips"}'


if [[ $# > 0 ]]; then
    # If you pass a target/subnet to this script, it will just scan that target
    TARGET=$1
    NMAP_FILE="${OUTPUT_DIR}/nmap-discovery-$PROJECT_NAME-top20-${TARGET}"
    # Target: Standard first pass recon scan
    nmap -v -sV -A -p "$TOP_TCP_INTERNAL" --open --reason -oA "${NMAP_FILE}" "$TARGET"

    # UDP scan
    sudo nmap -sU -sV -p "$TOP_UDP_INTERNAL" \
        --open \
        --reason \
        --script=snmp-sysdescr \
        --script-args="snmpcommunity=public" \
        -oA "nmap-${PROJECT_NAME}-udp-${TARGET}"
else
    # If no args passed to script, it will use the scope file variable to scan a file list of targets
    NMAP_FILE="${OUTPUT_DIR}/nmap-discovery-$PROJECT_NAME-top20"
    # From File: Standard first pass recon scan, top 20 ports
    echo -e "[*] Launching discovery Nmap scan against scope list, this may take awhile..."
    nmap -v -sV -A -p "$TOP_TCP_INTERNAL" --reason --open -iL "${SCOPE_FILE}" -oA "${NMAP_FILE}"
fi



if [[ ! "$(command -v xsltproc 2>&1)" ]]; then
    sudo apt-get -y install xsltproc
fi

# If there are issues with the custom XSL file, just remove the xsl from arguments to use the default
if [[ -f "${CUSTOM_XSL}" ]]; then
    xsltproc --timing --output "${NMAP_FILE}.html" "${CUSTOM_XSL}" "${NMAP_FILE}.xml"
else
    xsltproc --timing --output "${NMAP_FILE}.html" "${NMAP_FILE}.xml"
fi
sleep 1s
[[ "$?" -eq 0 ]] && firefox --new-tab "${NMAP_FILE}.html" &
sleep 5s

exit 0


### ==========================




