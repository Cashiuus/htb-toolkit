#!/bin/bash

WID=$(wmctrl -lp | grep 'root@' | cut "-d " -f1)
FF=$(wmctrl -lp | grep 'Firefox' | cut "-d " -f1)
BURP=$(wmctrl -lp | grep 'Burp' | cut "-d " -f1)
WS=$(wmctrl -lp | grep 'ftp' | cut "-d " -f1)
CHR=$(wmctrl -lp | grep 'Cher' | cut "-d " -f1)

wmctrl -i -r $FF -e 0,75,64,1798,936
wmctrl -i -r $WS -e 0,75,95,1798,938
wmctrl -i -r $BURP -e 0,75,64,1798,936
wmctrl -i -r $WID -e 0,75,65,1800,960
wmctrl -i -r $CHR -e 0,75,65,1798,934
