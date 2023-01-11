#!/bin/bash

# Ref: https://resources.infosecinstitute.com/topic/exploiting-nfs-share/


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
## =============[  CONSTANTS  ]============= ##
START_TIME=$(date +%s)
APP_PATH=$(readlink -f $0)
APP_BASE=$(dirname "${APP_PATH}")
APP_NAME=$(basename "${APP_PATH}")
APP_ARGS=$@
LINES=$(tput lines)
COLS=$(tput cols)
HOST_ARCH=$(dpkg --print-architecture)      # (e.g. output: "amd64")

PROJECT_HOME="${HOME}/htb/"
RESULTS_FILE="${PROJECT_HOME}/post-searching-keywords-results.txt"



# Output tree listing of the data - $1 being the mounted share or target dir to start at
#tree -a -p -h --du  -D


# Useful view: sort output by last modification time instead of alphabetically
#tree -t

# Data Searching starting points

# List files by date
ls -lrt


# Look for ssh directories
find -type d -name ".ssh"

# Search for "password" in this dir and subdirs among all files
find -type f -print0 | xargs -r0 grep -i -F 'password' -B2 -A2 | tee -a "${RESULTS_FILE}"

# Search for word chars + @ + digits (common weak password pattern)
# TODO: This needs tested to ensure it finds what we intend it to
find -type f -print0 | xargs -r0 grep -E '\w+@\d+'


# Find all files of a certain extension
find -type -f -name "*.conf"

find -type -f -name "*.pub"


find -name ".ssh"
