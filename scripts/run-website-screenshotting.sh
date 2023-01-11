#!/usr/bin/env bash
## =======================================================================================
# File:     website-screenshotting.sh
# Author:   Cashiuus
# Created:  12-May-2021     Revised:    25-Aug-2021
#
##-[ Info ]-------------------------------------------------------------------------------
# Purpose:      Convert an Nmap xml into HTML report, then screenshot
#               all websites via EyeWitness
#
# Notes:
#
#
##-[ Links/Credit ]-----------------------------------------------------------------------
#   * EyeWitness: https://www.christophertruncer.com/eyewitness-2-0-release-and-user-guide/
#
#
##-[ Copyright ]--------------------------------------------------------------------------
#   MIT License ~ http://opensource.org/licenses/MIT
## =======================================================================================
__version__="1.0.0"
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


OUTPUT_DIR="${HOME}/redcell/begos/phase2"
SCAN_DIR="${OUTPUT_DIR}/scans"
EYEWITNESS_DIR="${SCAN_DIR}/eyewitness-${DATE}"
USER_AGENT='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'
CUSTOM_XSL="${APP_BASE}/../config/nmap-thermo.xsl"
#CUSTOM_XSL="${APP_BASE}/../config/nmap-bootstrap.xsl"

## =======================================================================================

### ===============[ Process Arguments ]============== ###
for arg in "$@"; do
    if [[ "$arg" == "-h" ]] || [[ "$arg" == "--help" ]]; then
        echo -e "Usage: $0 <Nmap XML File>"
        echo -e ""
    else
        # For now, assume this is an nmap xml file for processing
        NMAP_XML="${arg}"
        if [[ ! -f ${NMAP_XML} ]]; then
            echo -e "${RED}[ERROR] Provided nmap xml file is invalid or not found!${RESET}"
            exit 1
        fi
    fi
done


if [[ ! $(which xsltproc) ]]; then
    sudo apt-get -qq update
    sudo apt-get -y install xsltproc
fi


# -----[ Begin ]----- #
cd "${OUTPUT_DIR}"
# Regardless if we do whole list or single subnet, put them all in dated directory
[[ ! -d "${SCAN_DIR}" ]] && mkdir -p "${SCAN_DIR}"

# Need nmap filename without xml extension for naming the html-generated file
NMAP_FILE=$(basename ${NMAP_XML} .xml)

# If there are issues with the custom XSL file, just remove the xsl from arguments to use the default
if [[ ! -f "${NMAP_FILE}.html" ]]; then
    # file doesn't exist, so let's create it
    echo -e "[*] Converting Nmap scan to an HTML report, please wait..."
    if [[ -f "${CUSTOM_XSL}" ]]; then
        xsltproc --timing --output "${NMAP_FILE}.html" "${CUSTOM_XSL}" "${NMAP_XML}"
    else
        xsltproc --timing --output "${NMAP_FILE}.html" "${NMAP_XML}"
    fi
else
    # Nmap has already been converted to an HTML, so proceed...
    echo -e "[*] Nmap HTML scan report already exists!"
fi
sleep 1s
[[ $? -eq 0 ]] && firefox --new-tab "${NMAP_FILE}.html" &
sleep 5s


# Run eyewitness, save to dir, jitter adding random delay, cycle browser
# user agents, use OCR to get RDP users
if [[ ! $(which eyewitness) ]]; then
    echo -e "${RED}[ERROR] EyeWitness not found! If on kali, install via: apt-get -y install EyeWitness${RESET}"
    sudo apt-get -qq update
    sudo apt-get -y install eyewitness
    if [[ "$?" -ne 0 ]]; then
        exit 1
    fi
fi

eyewitness \
    -x "${NMAP_XML}" \
    -d "${EYEWITNESS_DIR}" \
    --web \
    --jitter 10 \
    --threads 2 \
    --delay 3 \
    --user-agent "$USER_AGENT" \
    --no-prompt \
    --results 25


# Eyewitness does not allow you to specify the
# name of the output file "report.html"
if [[ "$?" -eq 0 ]]; then
    rm "${OUTPUT_DIR}/geckodriver.log"
    mv "${OUTPUT_DIR}/parsed_xml.txt" "${OUTPUT_DIR}/scope-urls_list.txt"

    if [[ -f "${EYEWITNESS_DIR}/report.html" ]]; then
        # TODO: Changing this makes links to the page_1 of report not work in the HTML code of report pages
        mv "${EYEWITNESS_DIR}/report.html" "${EYEWITNESS_DIR}/EyeWitness-Report-AllTargets.html"
        firefox --new-tab "${EYEWITNESS_DIR}/EyeWitness-Report-AllTargets.html" &
    else
        echo -e "${YELLOW}[WARNING]${RESET} Eyewitness did not create a report for this scan."
    fi

else
    echo -e "${RED}[ERROR] EyeWitness failed to finish, check geckodriver.log and retry${RESET}"
    exit 1
fi
# You can also search the results db for keywords and
# generate a report based on the search alone.
#python3 /usr/share/eyewitness/Search.py "${SCAN_DIR}/ew.db" Citrix

echo -e "${GREEN}[*]${RESET} Recon screenshotting is now complete, check Nmap and EyeWitness reports for action items.\n"
exit 0



## =======================================================================================




# Nmap scan syntax needed for a good import into Visio (intrinium add-on) - You'll use the XML output file
#       --script-args snmpcommunity=public     <-- add snmp name, if known
#sudo nmap -v -sSUV -O --top-ports=15 --traceroute --script=ms-sql-info,nbstat,smb-os-discovery,snmp-sysdescr \
#    -oA nmap-networkscan


## =======================================================================================
