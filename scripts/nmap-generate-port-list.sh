#!/bin/bash
## =======================================================================================
#   Nmap Ports Frequency Analysis (https://nmap.org/book/nmap-services.html)
#       - See bottom of file for functions that can grep top 'n' port lists for review




function get_top_ports_report() {
    # Usage: get_top_ports tcp 1000
    #
    #    $1      tcp, udp, both
    #
    #if [[ $2 =~ "^[0-9]+$" ]]; then
        ## the arg is a valid integer
        #echo -e ""
    #else
        #echo -e "[!] Invalid value passed for top 'n' ports for which you want to generate a list"
        #return
    #fi

    if [[ "$1" == "tcp" ]]; then
        echo -e "\n\n[*] Nmap top $2 ports, protocol $1:"
        grep 'tcp' /usr/share/nmap/nmap-services | awk '{gsub(/\t/," ");gsub("/"," "); print $1,$2,$3,$4}' | sort -n -t ' ' -k4 -r | grep -m $2 . | awk '{print $3,$2,$1,$4}'

    elif [[ "$1" == "udp" ]]; then
        echo -e "\n\n[*] Nmap top $2 ports, protocol $1:"
        grep 'udp' /usr/share/nmap/nmap-services | awk '{gsub(/\t/," ");gsub("/"," "); print $1,$2,$3,$4}' | sort -n -t ' ' -k4 -r | grep -m $2 . | awk '{print $3,$2,$1,$4}'

    elif [[ "$1" == "both" ]]; then
        echo -e "\n\n[*] Nmap top $2 ports, protocol $1:"
        # create a top 20 ports list (both udp and tcp)
        # Format: [name port protocol frequency]
        #grep 'tcp\|udp' /usr/share/nmap/nmap-services | awk '{gsub(/\t/," ");gsub("/"," "); print $1,$2,$3,$4}' | sort -n -t ' ' -k4 -r | grep -m 20 .
        # Format: [protocol port name]
        grep 'tcp\|udp' /usr/share/nmap/nmap-services | awk '{gsub(/\t/," ");gsub("/"," "); print $1,$2,$3,$4}' | sort -n -t ' ' -k4 -r | grep -m $2 . | awk '{print $3,$2,$1,$4}'
    else
        echo -e "[!] Invalid argument for this function!"
    fi

}
#get_top_ports_report tcp 500
#get_top_ports_report udp 100
get_top_ports_report both 10


function get_top_ports_for_script() {
    # Usage: get_top_ports tcp 1000
    #    $1      tcp, udp, both
    #
    # TODO: This is broken and says an integer is not an integer...
    #if [[ $2 =~ "^[0-9]+$" ]]; then
        ## the arg is a valid integer
        #echo -e ""
    #else
        #echo -e "[!] Invalid value passed for top 'n' ports arg"
        #return
    #fi

    if [[ "$1" == "tcp" ]]; then
        echo -e "\n\n[*] Nmap top $2 ports, protocol $1:"
        grep 'tcp' /usr/share/nmap/nmap-services | awk '{gsub(/\t/," ");gsub("/"," "); print $1,$2,$3,$4}' | sort -n -t ' ' -k4 -r | grep -m $2 . | awk '{print $2}' | tr '\n' , | sed 's/.$//'

    elif [[ "$1" == "udp" ]]; then
        echo -e "\n\n[*] Nmap top $2 ports, protocol $1:"
        grep 'udp' /usr/share/nmap/nmap-services | awk '{gsub(/\t/," ");gsub("/"," "); print $1,$2,$3,$4}' | sort -n -t ' ' -k4 -r | grep -m $2 . | awk '{print $2}' | tr '\n' , | sed 's/.$//'

    elif [[ "$1" == "both" ]]; then
        echo -e "\n\n[*] Nmap top $2 ports, protocol $1:"
        grep 'tcp\|udp' /usr/share/nmap/nmap-services | awk '{gsub(/\t/," ");gsub("/"," "); print $1,$2,$3,$4}' | sort -n -t ' ' -k4 -r | grep -m $2 . | awk '{print $2}' | tr '\n' , | sed 's/.$//'
    else
        echo -e "[!] Invalid argument for this function! (Valid: tcp, udp, both)"
    fi
}
#get_top_ports_for_script tcp 100
#get_top_ports_for_script udp 100
#get_top_ports_for_script both 100


# Showcase it with a basic example

get_top_ports_for_script tcp 100
get_top_ports_for_script tcp 300
get_top_ports_for_script tcp 500
get_top_ports_for_script tcp 1000

get_top_ports_for_script udp 50
get_top_ports_for_script udp 100
