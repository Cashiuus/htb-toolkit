#!/bin/bash
## =======================================================================================
# File:     launch-tmux.sh
# Author:   Cashiuus
# Created:  09-Oct-2021     Revised:    23-Aug-2022
#
# Purpose:  Launch a tmux session with full buildout of windows/panes for Hack The Box
#
#
# Some example scripts that do this:
#     - https://github.com/cpjolicoeur/tmux-go/blob/master/tmux-go
#
## =======================================================================================

if [[ -z $1 ]]; then
    echo -e "[ERR] Please pass a session name as an argument to this script"
    exit 1
fi

SESSION=$1

if tmux has-session -t $SESSION 2>/dev/null; then
    # Kill session so we can build a new one for testing.
    echo -e "[DEBUG] Killing session: $SESSION"
    tmux kill-session -t $SESSION
fi


if tmux has-session -t $SESSION 2>/dev/null; then
    echo -e "[ERR] Session already exists, attaching to it instead of building"
    echo -e "[DEBUG] Attaching to session: $SESSION"
    sleep 2s
    tmux -2 attach -t $SESSION
    exit 0
fi

# Otherwise, create our new session structure boilterplate
echo -e "[DEBUG] Creating new session: $SESSION"
tmux new-session -d -s $SESSION
# TODO: what's this do
#tmux set-option -t $SESSION -g set-remain-on-exit on

echo -e "[DEBUG] Renaming first window and creating new windows"
tmux rename-window -t $SESSION:0 main
tmux new-window -t $SESSION:1 -n msf
tmux new-window -t $SESSION:2 -n utility
tmux new-window -t $SESSION:3 -n vpn

# Split window vertically - v=vertical split, h=horizontal split
echo -e "[DEBUG] Splitting windows into panes"
tmux split-window -t $SESSION:0 -v
tmux split-window -t $SESSION:0.1 -h
tmux split-window -t $SESSION:1 -v
tmux split-window -t $SESSION:1.1 -h
tmux split-window -t $SESSION:2 -v
tmux split-window -t $SESSION:3 -h
tmux split-window -t $SESSION:3.1 -v

echo -e "[DEBUG] Setting directories for panes"
tmux send-keys -t $SESSION:0.0 "cd ${HOME}/htb/lab-offshore" C-m
tmux send-keys -t $SESSION:0.0 "clear" C-m
tmux send-keys -t $SESSION:0.1 "cd ${HOME}/htb/lab-offshore" C-m
tmux send-keys -t $SESSION:0.1 "clear" C-m
tmux send-keys -t $SESSION:0.2 "cd ${HOME}/transfer-stage" C-m
tmux send-keys -t $SESSION:0.2 "sudo python3 -m http.server 80"
tmux send-keys -t $SESSION:1.0 "cd ${HOME}" C-m
tmux send-keys -t $SESSION:1.0 "clear" C-m
tmux send-keys -t $SESSION:1.1 "cd ${HOME}/htb/lab-offshore" C-m
tmux send-keys -t $SESSION:1.1 "clear" C-m
tmux send-keys -t $SESSION:1.2 "cd ${HOME}/git" C-m
tmux send-keys -t $SESSION:1.2 "clear" C-m
#tmux select-layout tiled

# -- Send keys to certain panes
tmux send-keys -t $SESSION:1.0 "msfconsole" C-m
tmux send-keys -t $SESSION:3.0 "cd ${HOME}/htb" C-m
tmux send-keys -t $SESSION:3.0 "ssh -D 1080 -i /home/cashiuus/htb/lab-offshore/creds/ssh_L1_123_root root@10.10.110.123"
tmux send-keys -t $SESSION:3.1 "cd ${HOME}/vpn/htb" C-m
tmux send-keys -t $SESSION:3.1 "sudo openvpn "
tmux send-keys -t $SESSION:3.2 "cd ${HOME}/htb" C-m
tmux send-keys -t $SESSION:3.2 'sudo sshuttle -r root@10.10.110.123 172.16.1.0/24 -e "ssh -i /home/cashiuus/htb/lab-offshore/creds/ssh_L1_123_root"'


# Don't need window 2 - utility, but easier to kill it here rather than re-number everything
#tmux kill-window -t $SESSION:2

echo -e "\n[DEBUG] Tmux Create is Complete, Listing all windows and end of script"
tmux list-windows -t $SESSION

exit 0





## ========================================================================== ##
# Send-keys examples: https://minimul.com/increased-developer-productivity-with-tmux-part-5.html

# An example that can ssh into remote hosts in split panes

# Usage: script.sh host1 host2 host3 host4
#hosts=( "$@" )
#counthosts=${#hosts[@]}
#tmux send-keys "ssh ${hosts[0]}" C-m
#if [[ $counthosts -gt 1 ]]; then
#       for (( i=2; i<${counthosts}+1; i++ )); do
#               tmux split-window -h
#               tmux select-layout even-vertical
#               tmux send-keys "ssh ${hosts[$i-1]}" C-m
#       done
#fi

## Basic Commands

# tmux list-sessions [-F format] [-f filter]        # has an alias of 'ls'
# tmux rename-session [-t target-session] new-name  # alias "rename"


### Window Layout options

#A number of preset arrangements of panes are available, these are called layouts.  These may be selected with the
     #select-layout command or cycled with next-layout (bound to ‘Space’ by default); once a layout is chosen, panes within it may
     #be moved and resized as normal.

     #The following layouts are supported:

     #even-horizontal
             #Panes are spread out evenly from left to right across the window.

     #even-vertical
             #Panes are spread evenly from top to bottom.

     #main-horizontal
             #A large (main) pane is shown at the top of the window and the remaining panes are spread from left to right in the
             #leftover space at the bottom.  Use the main-pane-height window option to specify the height of the top pane.

     #main-vertical
             #Similar to main-horizontal but the large pane is placed on the left and the others spread from top to bottom along
             #the right.  See the main-pane-width window option.

     #tiled   Panes are spread out as evenly as possible over the window in both rows and columns.



#In addition, select-layout may be used to apply a previously used layout - the list-windows command displays the layout of
     #each window in a form suitable for use with select-layout.  For example:

           #$ tmux list-windows
           #0: ksh [159x48]
               #layout: bb62,159x48,0,0{79x48,0,0,79x48,80,0}
           #$ tmux select-layout bb62,159x48,0,0{79x48,0,0,79x48,80,0}

     #tmux automatically adjusts the size of the layout for the current window size.  Note that a layout cannot be applied to a
     #window with more panes than that from which the layout was originally defined.

## ========================================================================== ##
