#!/usr/bin/python

import os
import sys

def add_setting(root, file):
    file_extension = os.path.splitext(file)
    filename = root + "/" + file
    if extension == ".v":
        tag = "VERILOG_FILE"
    elif extension == ".sv":
        tag = "SYSTEMVERILOG_FILE"
    else:
        tag = None

    if tag != None:
        return "set_global_assignment -name " + tag + \
            "$MY_WORKDIR/" + filename + "\n"

if __name__ == "__main__":
    # traverse root directory, and list directories as dirs and files as files
    settings = ""
    for root, dirs, files in os.walk("."):
        # print root, dirs, files
        for file in files:
            settings += add_setting(root, file)
    print settings