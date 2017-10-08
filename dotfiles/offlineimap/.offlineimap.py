#!/usr/bin/python
import re, os

def get_password(machine, login, port):
    s = "machine %s login %s port %s password " % (machine, login, port)
    authinfo = os.popen("gpg2 -q --no-tty -d ~/.authinfo.gpg").read()
    for line in authinfo.split("\n"):
        if line.startswith(s):
            return line[len(s):]
    return ""
